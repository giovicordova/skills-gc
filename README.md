# skills-gc

Custom skills for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Each skill gives Claude a specific behaviour when invoked as a slash command.

## Skills

| Skill | What it does |
|-------|-------------|
| [checkpoint](skills/checkpoint/SKILL.md) | End-of-session handoff — writes one rich, narrative git commit (empty if no diff) so the next session reads `git log` and cold-starts with full context |
| [verify](skills/verify/SKILL.md) | Audits Claude's own output against the user's original request. PASS/PARTIAL/FAIL per requirement, flags scope creep |
| [plan-challenger](skills/plan-challenger/SKILL.md) | Stress-tests implementation plans before execution — researches alternatives, challenges complexity, returns a revised plan |
| [perspective](skills/perspective/SKILL.md) | Strategic reality check — checks whether the solution already exists, whether there's a better approach, against live docs not stale training data |
| [cc-audit](skills/cc-audit/SKILL.md) | Audits a project's Claude Code setup against official Anthropic docs across 9 areas, produces a scored AUDIT-REPORT.md |
| [coherency-check](skills/coherency-check/SKILL.md) | Cross-document and cross-code coherency analysis — finds contradictions, conflicting values, and overlapping definitions, resolves each interactively |
| [website-audit](skills/website-audit/SKILL.md) | SEO, AEO, GEO, and structured-data audit. Crawls with Playwright, runs Lighthouse, checks Perplexity citations, scores deterministically |

## Install

```bash
ln -s /path/to/skills-gc/skills/verify ~/.claude/skills/verify
```

Each skill directory has a `SKILL.md` with the full definition and an `evals/` folder with test cases.

## License

MIT
