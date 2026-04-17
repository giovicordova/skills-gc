# skills-gc

Custom skills for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Each skill gives Claude a specific behaviour — triggered automatically from context, or invoked manually as a slash command.

## Skills

| Skill | What it does |
|-------|-------------|
| [checkpoint](skills/checkpoint/SKILL.md) | End-of-session handoff — writes a one-line entry to `CHECKPOINTS.md` plus a matching git commit (subject = same line, body = full narrative). Next session reads the index first, opens full commit bodies only for the matches |
| [verify](skills/verify/SKILL.md) | Audits Claude's own output against the user's original request. PASS/PARTIAL/FAIL per requirement, flags scope creep |
| [plan-challenger](skills/plan-challenger/SKILL.md) | Stress-tests implementation plans before execution — researches alternatives, challenges complexity, returns a revised plan |
| [perspective](skills/perspective/SKILL.md) | Strategic reality check — checks whether the solution already exists, whether there's a better approach, against live docs not stale training data |
| [cc-audit](skills/cc-audit/SKILL.md) | Audits a project's Claude Code setup against official Anthropic docs across 9 areas, produces a scored AUDIT-REPORT.md |
| [coherency-check](skills/coherency-check/SKILL.md) | Cross-document and cross-code coherency analysis — finds contradictions, conflicting values, and overlapping definitions, resolves each interactively |
| [philosophier](skills/philosophier/SKILL.md) | Compresses verbose text into the shortest precise phrasing that preserves every constraint. Searches for established philosophical principles (YAGNI, Chesterton's Fence, Occam's Razor) when they're exact matches; falls back to raw distillation otherwise |
| [website-audit](skills/website-audit/SKILL.md) | SEO, AEO, GEO, and structured-data audit. Crawls with Playwright, runs Lighthouse, checks Perplexity citations, scores deterministically |
| [interactive-qa](skills/interactive-qa/SKILL.md) | Interactive Q&A that collects your decisions when agents present multiple options or disagree. Plain-language choices, recommendation flagged, dissent between agents surfaced. Produces a brief for Plan Mode, a specialist agent, or just context |

## Install

```bash
ln -s /path/to/skills-gc/skills/verify ~/.claude/skills/verify
```

Each skill directory has a `SKILL.md` with the full definition and an `evals/` folder with test cases.

## License

MIT
