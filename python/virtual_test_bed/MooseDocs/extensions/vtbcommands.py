import logging

from MooseDocs.base import components
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
    """Adds VTB-specific commands, e.g., "!vtbcontact"."""

    def extend(self, reader, renderer):
        self.requires(command, core)
        self.addCommand(reader, VtbContactCommand())
        renderer.add("VtbContactBoxToken", RenderVtbContactBoxToken())


def _split(value):
    """Split a ';'-separated setting into stripped, non-empty items."""
    if value is None:
        return []
    return [item.strip() for item in value.split(SEPARATOR) if item.strip()]

# Command to render the contacts for a model
class VtbContactCommand(command.CommandComponent):
    COMMAND = "vtbcontact"
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
                "%s: No 'name' provided for '!vtbcontact'; check markdown file.",
                page.name,
            )
            return parent
        if len(emails) != len(names):
            LOG.error(
                "%s: '!vtbcontact' has %d 'name' entries but %d 'email' entries; "
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

class RenderVtbContactBoxToken(components.RenderComponent):
    def createHTML(self, parent, token, page):
        return html.Tag(parent, "div", token)
