import logging
import re

from MooseDocs.base import components, MarkdownReader
from MooseDocs.tree import html, tokens
from MooseDocs.extensions import autolink, command, core
from MooseDocs.tree import pages

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


# Navigation buttons placed at the end of the sub-pages of a multi-page model
VtbPageNavToken = tokens.newToken(
    "VtbPageNavToken", home=None, previous=None, next=None, top=False
)

# "!vtb_model_nav" followed by an indented block with one page name per line
PAGE_ORDER_RE = re.compile(
    r"^!vtb_model_nav[^\n]*\n((?:[ \t]+\S[^\n]*(?:\n|\Z)|[ \t]*\n)*)", flags=re.MULTILINE
)
CODE_BLOCK_RE = re.compile(r"^```.*?^```", flags=re.MULTILINE | re.DOTALL)
TITLE_RE = re.compile(r"^#[ \t]+(.+?)[ \t]*$", flags=re.MULTILINE)


def make_extension(**kwargs):
    return VtbCommandsExtension(**kwargs)

# Extension to add various VTB documentation commands
class VtbCommandsExtension(command.CommandExtension):
    """Adds VTB-specific commands, e.g., "!vtb_model_summary"."""

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # {page local name: {"home": local, "previous": local|None, "next": local|None}}
        self._nav = dict()
        # {page local name: title (first heading of the source)}
        self._titles = dict()

    def preExecute(self):
        """Gather the page order of every model home page ("!vtb_model_nav").

        Pages are tokenized independently (possibly in parallel), so the order is read here
        from the sources, once, and each sub-page looks up its neighbors from it.
        """
        self._nav = dict()
        self._titles = dict()
        for home in self.translator.findPages(lambda p: isinstance(p, pages.Source)):
            try:
                with open(home.source, encoding="utf-8") as f:
                    content = f.read()
            except OSError:
                continue
            # Examples of the command in code blocks are not model home pages
            match = PAGE_ORDER_RE.search(CODE_BLOCK_RE.sub("", content))
            if match is None:
                continue

            order = []
            for name in _page_names(match.group(1)):
                page = self.translator.findPage(name, throw_on_zero=False, warn_on_zero=True)
                if page is not None:
                    order.append(page)
            for i, page in enumerate(order):
                if page.local in self._nav:
                    LOG.error(
                        "%s: page is listed in the '!vtb_model_nav' of both '%s' and '%s'.",
                        page.local,
                        self._nav[page.local]["home"],
                        home.local,
                    )
                    continue
                self._nav[page.local] = dict(
                    home=home.local,
                    previous=order[i - 1].local if i > 0 else None,
                    next=order[i + 1].local if i + 1 < len(order) else None,
                )
            for page in [home] + order:
                self._titles[page.local] = self._title(page)

    @staticmethod
    def _title(page):
        try:
            with open(page.source, encoding="utf-8") as f:
                match = TITLE_RE.search(f.read())
        except OSError:
            match = None
        return match.group(1) if match else page.name

    def title(self, local):
        return self._titles.get(local, local)

    def postTokenize(self, page, ast):
        """Add the home/previous buttons after the title of a sub-page and home/next at the
        end, before any references."""
        nav = self._nav.get(page.local)
        if nav is None:
            return

        # Right after the page title, the first level 1 heading
        for i, node in enumerate(ast.children):
            if node.name == "Heading" and node["level"] == 1:
                ast.insert(
                    i + 1,
                    VtbPageNavToken(
                        None, class_="vtb-page-nav vtb-page-nav-top", top=True, **nav
                    ),
                )
                break
        else:
            LOG.error(
                "%s: a page in a '!vtb_model_nav' list requires a level 1 heading ('# Title') "
                "for the navigation buttons to follow.",
                page.local,
            )
        token = VtbPageNavToken(None, class_="vtb-page-nav", **nav)

        # Before the bibliography, and its "References" heading, if there is one. The bibtex
        # extension may or may not have added it yet, in which case it will add it after.
        index = len(ast.children)
        for i, node in enumerate(ast.children):
            if node.name == "BibtexBibliography":
                index = i
                if i > 0 and ast.children[i - 1].name == "Heading":
                    index = i - 1
                break
        ast.insert(index, token)

    def extend(self, reader, renderer):
        self.requires(command, core, autolink)
        self.addCommand(reader, VtbModelSummaryCommand())
        self.addCommand(reader, VtbModelNavCommand())
        renderer.add("VtbPageNavToken", RenderVtbPageNavToken())
        renderer.add("VtbContactBoxToken", RenderVtbContactBoxToken())
        renderer.add("VtbModelSummaryToken", RenderVtbModelSummaryToken())


def _split(value):
    """Split a ';'-separated setting into stripped, non-empty items."""
    if value is None:
        return []
    return [item.strip() for item in value.split(SEPARATOR) if item.strip()]

def _page_names(block):
    """The page names in the block of a '!vtb_model_nav', one per line."""
    return [line.strip() for line in block.splitlines() if line.strip()]

# Command for the home page of a model with several pages. Renders the list of contents and
# defines the order used for the navigation buttons that are added to each of the pages.
class VtbModelNavCommand(command.CommandComponent):
    COMMAND = "vtb_model_nav"
    SUBCOMMAND = None
    # The indented page names are read as the (multi-line) settings of the command; keep them raw
    PARSE_SETTINGS = False

    def createToken(self, parent, info, page, settings):
        names = _page_names(settings)
        if not names:
            LOG.error(
                "%s: '!vtb_model_nav' requires an indented list of pages, one per line.",
                page.name,
            )
            return parent
        core.Heading(parent, level=2, string="Contents")
        outline = core.UnorderedList(parent)
        for name in names:
            autolink.AutoLink(core.ListItem(outline), page=name)
        return parent

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
        # One column per piece of information, with a small uppercase heading above the content;
        # styled in doc/content/css/vtb_theme.css
        columns = html.Tag(box, "div", class_="vtb-summary-columns")

        def add_column(title, class_=""):
            column = html.Tag(columns, "div", class_="vtb-summary-column " + class_)
            html.String(html.Tag(column, "span", class_="vtb-summary-label"), content=title)
            return column

        if token["github_url"]:
            # The GitHub logo of the header bar, linking to the model; styled in
            # doc/content/css/vtb_theme.css
            logo = self.translator.findPage("github-mark.png", throw_on_zero=False, warn_on_zero=True)
            column = html.Tag(columns, "div", class_="vtb-summary-column vtb-summary-github")
            link = html.Tag(
                column,
                "a",
                class_="vtb-github-button",
                href=token["github_url"],
                title="View on GitHub",
            )
            if logo:
                html.Tag(
                    link,
                    "img",
                    src=str(logo.relativeDestination(page)),
                    alt="View on GitHub",
                )

        for key, title in (
            ("fiscal_year", "Fiscal year"),
            ("computing_needs", "Computing needs"),
        ):
            if key_vals.get(key):
                html.String(html.Tag(add_column(title), "span"), content=key_vals[key])

        codes = _split(key_vals.get("codes_used"))
        if codes:
            # Every code links to the VTB codes page; tag values do not match its headings
            codes_page = self.translator.findPage(
                CODES_PAGE, throw_on_zero=False, warn_on_zero=True
            )
            url = str(codes_page.relativeDestination(page)) if codes_page else None
            code_list = html.Tag(add_column("Codes used"), "ul")
            for code in codes:
                item = html.Tag(code_list, "li")
                if url:
                    html.String(html.Tag(item, "a", href=url), content=code)
                else:
                    html.String(item, content=code)

        names = token["contact_names"]
        contacts = html.Tag(
            add_column("Contact" if len(names) == 1 else "Contacts", "vtb-summary-wide"), "ul"
        )
        for name, email in zip(names, token["contact_emails"]):
            item = html.Tag(contacts, "li")
            html.String(item, content=name + " (")
            html.String(html.Tag(item, "a", href="mailto:" + email), content=email)
            html.String(item, content=")")

        # V&V is the only child of the token
        vv_column = add_column("Verification and validation", "vtb-summary-wide")
        for child in token.children:
            self.renderer.render(vv_column, child, page)

        return None

class RenderVtbContactBoxToken(components.RenderComponent):
    def createHTML(self, parent, token, page):
        return html.Tag(parent, "div", token)


class RenderVtbPageNavToken(components.RenderComponent):
    def createHTML(self, parent, token, page):
        # Buttons are styled in doc/content/css/vtb_theme.css
        div = html.Tag(parent, "div", token)
        ext = self.extension

        def add_button(local, label, show_title=False):
            target = self.translator.findPage(local, exact=True, throw_on_zero=False)
            if target is None:
                return
            button = html.Tag(
                div, "a", class_="vtb-nav-button", href=str(target.relativeDestination(page))
            )
            # The label and the title are colored differently, see doc/content/css/vtb_theme.css
            html.String(html.Tag(button, "span", class_="vtb-nav-label"), content=label)
            if show_title:
                html.String(
                    html.Tag(button, "span", class_="vtb-nav-title"),
                    content=" " + ext.title(local),
                )

        if token["top"]:
            add_button(token["home"], "Model Home")
            if token["previous"]:
                add_button(token["previous"], "\u25c0 Previous:", show_title=True)
        else:
            add_button(token["home"], "Model Home")
            if token["next"]:
                add_button(token["next"], "\u25b6 Next:", show_title=True)
        return div
