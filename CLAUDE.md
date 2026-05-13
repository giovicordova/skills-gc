# CLAUDE.md

Guidance for Claude Code in this repo: custom skills built with skill-creator. Each triggers from context or as a slash command (`/wrap`, `/verify`).

User is not a developer. Reply in seconds, plain language, what and why not how. Link out for depth.

## Editing prose
For markdown with existing signal (README, SKILL.md, CLAUDE.md), dispatch `hermetic-distiller`: distill, don't regenerate.

## Repo layout
Each skill at `skills/<name>/`. Required: `SKILL.md` (frontmatter `description:` is the trigger contract; `allowed-tools:` pre-approves tools; body is instructions). Optional: `evals/evals.json` (test cases), `references/`, `agents/`, `modules/`, `scripts/`, `<skill>-workspace/` (eval output, gitignored). `README.md` is the public skills table: keep in sync with each `SKILL.md` `description:`.

## Install
```bash
ln -s /path/to/skills-gc/skills/<name> ~/.claude/skills/<name>
```

## Editing SKILL.md
`description:` is load-bearing: it decides invocation. Cover triggers, output, negative scope ("NOT for X"). When changed, update the README row (use `coherency-check` if multiple files moved).
