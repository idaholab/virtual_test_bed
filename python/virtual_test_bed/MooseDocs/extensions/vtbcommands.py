import logging

from MooseDocs.base import components, MarkdownReader
from MooseDocs.tree import html, tokens
from MooseDocs.extensions import command, core

LOG = logging.getLogger(__name__)

SEPARATOR = ";"

# A plain <div> that holds the contact label and list
VtbContactBoxToken = tokens.newToken("VtbContactBoxToken")


def make_extension(**kwargs):
    return VtbCommandsExtension(**kwargs)

# Extension to add various VTB documentation commands
class VtbCommandsExtension(command.CommandExtension):
    """Adds VTB-specific commands, e.g., "!vtb_contact"."""

    def extend(self, reader, renderer):
        self.requires(command, core)
        self.addCommand(reader, VtbContactCommand())
        self.addCommand(reader, VtbVVSummaryCommand())
        renderer.add("VtbContactBoxToken", RenderVtbContactBoxToken())


def _split(value):
    """Split a ';'-separated setting into stripped, non-empty items."""
    if value is None:
        return []
    return [item.strip() for item in value.split(SEPARATOR) if item.strip()]

# Command to render the contacts for a model
class VtbContactCommand(command.CommandComponent):
    COMMAND = "vtb_contact"
    SUBCOMMAND = None

    @staticmethod
    def defaultSettings():
        settings = command.CommandComponent.defaultSettings()
        settings["name"] = (
            None,
            "Contact name(s). Separate multiple contacts with ';'.",
        )
        settings["email"] = (
            None,
            "Required. Contact email address(es), in the same order as 'name'. "
            "Separate multiple addresses with ';'.",
        )
        return settings

    def createToken(self, parent, info, page, settings):
        names = _split(settings["name"])
        emails = _split(settings["email"])

        if not names:
            LOG.error(
                "%s: No 'name' provided for '!vtb_contact'; check markdown file.",
                page.name,
            )
            return parent
        if len(emails) != len(names):
            LOG.error(
                "%s: '!vtb_contact' has %d 'name' entries but %d 'email' entries; "
                "each contact needs exactly one email, and ';' must separate each entry.",
                page.name,
                len(names),
                len(emails),
            )
            return parent

        # NRIC box style, defined in doc/content/css/vtb_theme.css
        box = VtbContactBoxToken(parent, class_="nric-media-box vtb-contact")
        label = core.Paragraph(box)
        strong = core.Strong(label)
        tokens.String(strong, content="Contact:" if len(names) == 1 else "Contacts:")

        items = core.UnorderedList(box)
        for i, name in enumerate(names):
            item = core.ListItem(items)
            tokens.String(item, content=name + " (")
            link = core.Link(item, url="mailto:" + emails[i])
            tokens.String(link, content=emails[i])
            tokens.String(item, content=")")

        return parent

# Command to render a "V&V Summary" box, one bullet per line of block content, or a
# disclaimer when there is no content
class VtbVVSummaryCommand(command.CommandComponent):
    COMMAND = "vtb_vv_summary"
    SUBCOMMAND = None

    def createToken(self, parent, info, page, settings):
        # "block" is None when no lines follow the command
        lines = [line.strip() for line in (info["block"] or "").splitlines()]
        lines = [line for line in lines if line]
        # NRIC box styles, defined in doc/content/css/vtb_theme.css
        if not lines:
            box = VtbContactBoxToken(parent, class_="nric-media-box vtb-summary-none")
            note = core.Paragraph(box)
            tokens.String(
                note,
                content="No verification and validation has been documented for this model.",
            )
            return parent

        box = VtbContactBoxToken(parent, class_="nric-media-box vtb-summary")
        label = core.Paragraph(box)
        strong = core.Strong(label)
        tokens.String(strong, content="Verification and Validation Summary:")

        items = core.UnorderedList(box)
        for line in lines:
            item = core.ListItem(items)
            self.reader.tokenize(item, line, page, MarkdownReader.INLINE)

        return parent

class RenderVtbContactBoxToken(components.RenderComponent):
    def createHTML(self, parent, token, page):
        return html.Tag(parent, "div", token)
