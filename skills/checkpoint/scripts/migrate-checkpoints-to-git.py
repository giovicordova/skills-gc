#!/usr/bin/env python3
"""Migrate legacy logs/*_checkpoint.json files into git history.

Older versions of the checkpoint skill wrote session records to
`logs/*_checkpoint.json` (with `logs/` gitignored). The current
checkpoint skill writes a git commit per session instead, with the
narrative in the commit body. This script imports the legacy logs
into git history as a single bulk commit so the old session records
are preserved alongside everything else in `git log`.

Usage (run from the project root):

    python3 skills/checkpoint/scripts/migrate-checkpoints-to-git.py

Behaviour:
    1. Read every `logs/*_checkpoint.json` in the project.
    2. Sort by date (filename is timestamped).
    3. Build a single long-form commit body that includes each
       checkpoint as its own ## section, in chronological order.
    4. Print the body to stdout AND save it to /tmp so the operator
       can review it before committing.
    5. Print the exact `git commit --allow-empty` command to run.

The script does NOT commit anything itself. The operator runs the
printed command after reviewing the body. This keeps the
"never commit on the user's behalf" rule that the checkpoint skill
itself follows.

After committing, you can `rm -rf logs/` — the history is now in git.

Edge cases:
    - No `logs/` directory or empty: prints "nothing to migrate".
    - JSON parse error on any file: prints the bad file and skips.
    - SUMMARY.md is read for context but not migrated separately
      (the JSONs are the source of truth).
"""
import json
import sys
from pathlib import Path


def render_checkpoint(data: dict) -> str:
    """Render one checkpoint JSON as a markdown section."""
    lines = []
    date = data.get("date", "unknown date")
    branch = data.get("branch", "?")
    summary = data.get("summary", "")
    lines.append(f"### {date} (branch: {branch})")
    lines.append("")
    if summary:
        lines.append(f"**Summary:** {summary}")
        lines.append("")
    if (wh := data.get("what_happened")):
        lines.append("**What happened:**")
        lines.append("")
        lines.append(wh)
        lines.append("")
    if (steps := data.get("next_steps")):
        lines.append("**Next steps (as captured at the time):**")
        for s in steps:
            lines.append(f"- {s}")
        lines.append("")
    if (changed := data.get("what_changed")):
        lines.append("**Files / areas changed:**")
        for c in changed:
            lines.append(f"- {c}")
        lines.append("")
    if (findings := data.get("findings")):
        lines.append("**Findings:**")
        for f in findings:
            lines.append(f"- {f}")
        lines.append("")
    if (decisions := data.get("decisions")):
        lines.append("**Decisions:**")
        for d in decisions:
            lines.append(f"- {d}")
        lines.append("")
    state = data.get("state") or {}
    if state:
        lines.append("**State at checkpoint:**")
        for key in ("done", "in_progress", "blocked"):
            items = state.get(key) or []
            if items:
                lines.append(f"- {key}:")
                for it in items:
                    lines.append(f"  - {it}")
        lines.append("")
    git = data.get("git") or {}
    if git:
        last = git.get("last_commit", "")
        uncommitted = git.get("uncommitted", "")
        if last:
            lines.append(f"**Git state at checkpoint:** last commit `{last}`")
        if uncommitted:
            lines.append(f"**Uncommitted at checkpoint:** {uncommitted}")
        lines.append("")
    return "\n".join(lines).rstrip() + "\n"


def main() -> int:
    project_root = Path.cwd()
    logs_dir = project_root / "logs"
    if not logs_dir.is_dir():
        print("nothing to migrate: no logs/ directory in current working directory")
        return 0

    json_files = sorted(logs_dir.glob("*_checkpoint.json"))
    if not json_files:
        print(f"nothing to migrate: {logs_dir} has no *_checkpoint.json files")
        return 0

    sections: list[str] = []
    for jf in json_files:
        try:
            with open(jf) as f:
                data = json.load(f)
        except (OSError, json.JSONDecodeError) as e:
            print(f"warning: skipping {jf.name} ({e})", file=sys.stderr)
            continue
        sections.append(render_checkpoint(data))

    if not sections:
        print("nothing to migrate: no parseable checkpoint JSON files")
        return 0

    body_parts = [
        "Backfill historical session checkpoints from logs/",
        "",
        "## Summary",
        f"Importing {len(sections)} legacy session checkpoints from "
        "`logs/*_checkpoint.json` (written by an earlier version of the "
        "checkpoint skill that used parallel JSON files instead of git "
        "commits) into git history. After this commit, `logs/` can be "
        "deleted — every session record lives in `git log`.",
        "",
        "## What happened",
        "An older version of the checkpoint skill wrote session handoffs "
        "to `logs/*_checkpoint.json` files plus a `logs/SUMMARY.md` index, "
        "with `logs/` gitignored so they never reached git. The current "
        "version writes one git commit per session (empty if no diff) "
        "with the entire narrative in the commit body. This commit "
        "imports the previously orphaned checkpoints into git so the "
        "history is reachable from `git log` and pushable to remote.",
        "",
        "## Imported checkpoints (chronological order)",
        "",
    ]
    body_parts.extend(sections)
    body_parts.extend(
        [
            "",
            "## State",
            "- Done: legacy checkpoints imported, original JSONs can now be deleted.",
            "- In progress: nothing.",
            "- Blocked: nothing.",
            "",
            "Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>",
        ]
    )
    body = "\n".join(body_parts)

    out_path = Path("/tmp") / "checkpoint-migration-body.txt"
    out_path.write_text(body)

    print(f"Built migration body for {len(sections)} checkpoint(s).")
    print(f"Body saved to: {out_path}")
    print()
    print("Review the body, then run:")
    print()
    print(f"  git commit --allow-empty -F {out_path}")
    print()
    print("After committing, you can clean up the legacy files:")
    print()
    print("  rm -rf logs/")
    print()
    return 0


if __name__ == "__main__":
    sys.exit(main())
