# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Claude Code skills, built with skill-creator. Each skill triggers from context or as a slash command (`/wrap`, `/verify`).

User is not a developer. Replies in seconds, plain language, what and why not how. Link out for depth.

# Editing prose

For markdown with existing signal (README, SKILL.md, CLAUDE.md), dispatch `hermetic-distiller` — distill, don't regenerate.

# Repo layout

Each skill at `skills/<name>/`:

- `SKILL.md` — required. Frontmatter `description:` is the trigger contract (controls auto-invocation); `allowed-tools:` pre-approves tools. Body is instructions.
- `evals/evals.json` — optional test cases (`prompt` + `expected_output`), run by skill-creator.
- `references/`, `agents/`, `modules/`, `scripts/` — optional on-demand assets.
- `<skill>-workspace/` or `workspace/` — skill-creator eval output. Gitignored; delete when stale.

`README.md` is the public skills table — keep in sync with `SKILL.md` `description:` (triggers and outputs must agree).

# Installing

```bash
ln -s /path/to/skills-gc/skills/<name> ~/.claude/skills/<name>
```

# Editing SKILL.md

`description:` is load-bearing — it decides invocation. Cover trigger phrases, output, and negative scope ("NOT for X"). When you change it, update the README row (use `coherency-check` if multiple files moved).
