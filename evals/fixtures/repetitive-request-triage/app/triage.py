#!/usr/bin/env python3
"""Deterministic action-queue fixture for FlowForge's productivity track."""

from pathlib import Path
import sys


PRIORITY_WORDS = {
    "P1": ("outage", "blocked", "security", "urgent"),
    "P2": ("today", "deadline", "failed", "broken"),
}


def priority(note: str) -> str:
    lowered = note.lower()
    for label in ("P1", "P2"):
        if any(word in lowered for word in PRIORITY_WORDS[label]):
            return label
    return "P3"


def render(notes: list[str]) -> str:
    grouped = {label: [] for label in ("P1", "P2", "P3")}
    for note in notes:
        cleaned = note.strip()
        if cleaned:
            grouped[priority(cleaned)].append(cleaned)

    lines = ["# Action queue", "", f"Items: {sum(len(items) for items in grouped.values())}", ""]
    for label in grouped:
        lines.extend([f"## {label}", ""])
        lines.extend(f"- [ ] {note}" for note in grouped[label])
        lines.append("")
    return "\n".join(lines).rstrip() + "\n"


def selftest() -> None:
    output = render(["API outage blocks customer exports", "Send the monthly usage report today", "Refresh onboarding notes"])
    assert "## P1" in output
    assert "## P2" in output
    assert "## P3" in output
    assert "Items: 3" in output


def main() -> int:
    if len(sys.argv) == 2 and sys.argv[1] == "--selftest":
        selftest()
        print("selftest: ok")
        return 0
    if len(sys.argv) != 2:
        print("usage: triage.py NOTES_FILE", file=sys.stderr)
        return 2
    try:
        notes = Path(sys.argv[1]).read_text(encoding="utf-8").splitlines()
        print(render(notes), end="")
    except OSError as exc:
        print(str(exc), file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
