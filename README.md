# skills-gc

Custom skills for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Each skill gives Claude a specific behaviour when invoked as a slash command.

## Skills

| Skill | What it does |
|-------|-------------|
| [checkpoint](checkpoint/SKILL.md) | Session handoff — writes a structured log so the next session starts with full context |
| [verify](verify/SKILL.md) | Audits Claude's output against the original request. PASS/PARTIAL/FAIL per requirement |
| [plan-challenger](plan-challenger/SKILL.md) | Stress-tests plans before execution — researches alternatives, challenges complexity |
| [perspective](perspective/SKILL.md) | Strategic reality check — existing solutions, better approaches, live best practices |
| [cc-audit](cc-audit/SKILL.md) | Audits a project's Claude Code setup against official Anthropic docs |
| [coherency-check](coherency-check/SKILL.md) | Cross-document/code coherency analysis — finds contradictions, resolves interactively |
| [website-audit](website-audit/SKILL.md) | SEO, AEO, GEO, and structured data audit with deterministic scoring |

## Install

```bash
ln -s /path/to/skills-gc/verify ~/.claude/skills/verify
```

Each skill directory has a `SKILL.md` with the full definition and an `evals/` folder with test cases.

## License

MIT
