import logging

from MooseDocs.base import components, MarkdownReader
from MooseDocs.tree import html, tokens
from MooseDocs.extensions import command, core

LOG = logging.getLogger(__name__)

SEPARATOR = ";"

# Page listing the models by code used, linked from the codes in the model summary
CODES_PAGE = "models_by_codes_used.md"

# A plain <div> that holds the label and content of a box
VtbContactBoxToken = tokens.newToken("VtbContactBoxToken")

# Placeholder for the model summary box; filled in at render time from the page's "!tag"
VtbModelSummaryToken = tokens.newToken(
    "VtbModelSummaryToken", github_url=None, contact_names=[], contact_emails=[]
)


def make_extension(**kwargs):
    return VtbCommandsExtension(**kwargs)

# Extension to add various VTB documentation commands
class VtbCommandsExtension(command.CommandExtension):
    """Adds VTB-specific commands, e.g., "!vtb_model_summary"."""

    def extend(self, reader, renderer):
        self.requires(command, core)
        self.addCommand(reader, VtbModelSummaryCommand())
        renderer.add("VtbContactBoxToken", RenderVtbContactBoxToken())
        renderer.add("VtbModelSummaryToken", RenderVtbModelSummaryToken())


def _split(value):
    """Split a ';'-separated setting into stripped, non-empty items."""
    if value is None:
        return []
    return [item.strip() for item in value.split(SEPARATOR) if item.strip()]

# Command to render a "Model Summary" box from the tags of the page. The tag is looked up when
# rendering so that "!tag" may appear before or after this command.
class VtbModelSummaryCommand(command.CommandComponent):
    COMMAND = "vtb_model_summary"
    SUBCOMMAND = None

    @staticmethod
    def defaultSettings():
        settings = command.CommandComponent.defaultSettings()
        settings["github_url"] = (
            None,
            "URL of the model directory on GitHub; adds a 'VIEW ON GITHUB' button.",
        )
        settings["vv_summary"] = (
            None,
            "Verification and validation (V&V) items. Separate multiple items with ';' "
            "(use '\\=' for a literal '='). Inline markdown may be used. If omitted, a bullet "
            "states that no V&V has been documented.",
        )
        settings["contact_names"] = (
            None,
            "Required. Contact name(s). Separate multiple contacts with ';'.",
        )
        settings["contact_emails"] = (
            None,
            "Required. Contact email address(es), in the same order as 'contact_names'. "
            "Separate multiple addresses with ';'.",
        )
        return settings

    def createToken(self, parent, info, page, settings):
        names = _split(settings["contact_names"])
        emails = _split(settings["contact_emails"])

        if not names:
            LOG.error(
                "%s: No 'contact_names' provided for '!vtb_model_summary'; check markdown file.",
                page.name,
            )
            return parent
        if len(emails) != len(names):
            LOG.error(
                "%s: '!vtb_model_summary' has %d 'contact_names' entries but %d "
                "'contact_emails' entries; each contact needs exactly one email, and ';' "
                "must separate each entry.",
                page.name,
                len(names),
                len(emails),
            )
            return parent

        # NRIC box style, defined in doc/content/css/vtb_theme.css
        box = VtbModelSummaryToken(
            parent,
            class_="nric-media-box vtb-model-summary",
            github_url=settings["github_url"],
            contact_names=names,
            contact_emails=emails,
        )

        # The V&V content is a child of the token so that inline markdown is tokenized; the
        # renderer places it between the content generated from the tag
        vv = VtbContactBoxToken(box)
        strong = core.Strong(core.Paragraph(vv))
        tokens.String(strong, content="Verification and Validation:")
        items = core.UnorderedList(vv)
        vv_items = _split(settings["vv_summary"])
        if not vv_items:
            tokens.String(
                core.ListItem(items),
                content="No verification and validation has been documented for this model.",
            )
        for vv_item in vv_items:
            item = core.ListItem(items)
            self.reader.tokenize(item, vv_item, page, MarkdownReader.INLINE)
        return parent

class RenderVtbModelSummaryToken(components.RenderComponent):
    def createHTML(self, parent, token, page):
        tag = None
        for node in token.root.descendants:
            if node.name == "Tag":
                tag = node
                break
        if tag is None:
            LOG.error(
                "%s: '!vtb_model_summary' requires a '!tag' on the same page.", page.name
            )
            return None

        key_vals = tag["key_vals"]
        box = html.Tag(parent, "div", token)
        if token["github_url"]:
            # Yellow button, defined in doc/content/css/vtb_theme.css
            button = html.Tag(
                box, "a", class_="vtb-github-button", href=token["github_url"]
            )
            html.String(button, content="VIEW ON GITHUB")

        def add_line(key, title):
            if key_vals.get(key):
                line = html.Tag(box, "p")
                html.String(html.Tag(line, "strong"), content=title)
                html.String(line, content=" " + key_vals[key])

        add_line("fiscal_year", "Fiscal year:")

        # V&V is the only child of the token
        for child in token.children:
            self.renderer.render(box, child, page)

        add_line("computing_needs", "Computing needs:")

        codes = _split(key_vals.get("codes_used"))
        if codes:
            line = html.Tag(box, "p")
            html.String(html.Tag(line, "strong"), content="Codes used:")
            # Every code links to the VTB codes page; tag values do not match its headings
            codes_page = self.translator.findPage(
                CODES_PAGE, throw_on_zero=False, warn_on_zero=True
            )
            url = str(codes_page.relativeDestination(page)) if codes_page else None
            # "browser-default" keeps the bullets, which Materialize removes otherwise
            code_list = html.Tag(box, "ul", class_="browser-default")
            for code in codes:
                item = html.Tag(code_list, "li")
                if url:
                    html.String(html.Tag(item, "a", href=url), content=code)
                else:
                    html.String(item, content=code)

        names = token["contact_names"]
        label = html.Tag(box, "p")
        html.String(
            html.Tag(label, "strong"),
            content="Contact:" if len(names) == 1 else "Contacts:",
        )
        contacts = html.Tag(box, "ul", class_="browser-default")
        for name, email in zip(names, token["contact_emails"]):
            item = html.Tag(contacts, "li")
            html.String(item, content=name + " (")
            html.String(html.Tag(item, "a", href="mailto:" + email), content=email)
            html.String(item, content=")")

        # The children (V&V) are rendered above, in the desired position
        return None

class RenderVtbContactBoxToken(components.RenderComponent):
    def createHTML(self, parent, token, page):
        return html.Tag(parent, "div", token)
