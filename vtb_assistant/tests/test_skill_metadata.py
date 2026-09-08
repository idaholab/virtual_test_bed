import re
from pathlib import Path

SKILL_MD = Path(__file__).resolve().parent.parent / "skills" / "vtb-docs" / "SKILL.md"


def _frontmatter() -> dict[str, str]:
    text = SKILL_MD.read_text(encoding="utf-8")
    match = re.match(r"^---\n(.*?)\n---\n", text, re.DOTALL)
    assert match, "SKILL.md must start with a --- frontmatter block"
    fields = {}
    for line in match.group(1).splitlines():
        key, _, value = line.partition(":")
        fields[key.strip()] = value.strip()
    return fields


def test_skill_md_exists() -> None:
    assert SKILL_MD.is_file()


def test_frontmatter_has_name() -> None:
    fields = _frontmatter()
    assert fields.get("name") == "vtb-docs"


def test_frontmatter_description_is_sane() -> None:
    fields = _frontmatter()
    description = fields.get("description", "")
    assert description
    assert len(description) < 1024
