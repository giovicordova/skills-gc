# skills-gc

Custom skills for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Each gives Claude a specific behaviour — triggered from context, or invoked as a slash command.

## Skills

| Skill | What it does |
|-------|-------------|
| [wrap](skills/wrap/SKILL.md) | End-of-session routine: saves durable signal to project auto-memory, commits with session-narrative message, pushes upstream. Manual `/wrap`; pre-approves git tools while active |
| [verify](skills/verify/SKILL.md) | Audits Claude's output against the original request. PASS/PARTIAL/FAIL per requirement, flags scope creep |
| [plan-challenger](skills/plan-challenger/SKILL.md) | Stress-tests implementation plans pre-execution — researches alternatives, challenges complexity, returns a revised plan |
| [perspective](skills/perspective/SKILL.md) | Strategic reality check against live docs (not stale training): does the solution exist, is there a better approach |
| [cc-audit](skills/cc-audit/SKILL.md) | Audits a project's Claude Code setup against Anthropic docs across 9 areas; produces scored AUDIT-REPORT.md |
| [coherency-check](skills/coherency-check/SKILL.md) | Cross-document and cross-code coherency: finds contradictions, conflicting values, overlapping definitions; resolves each interactively |
| [philosophier](skills/philosophier/SKILL.md) | Compresses verbose text to shortest precise phrasing preserving every constraint. Cites established principles (YAGNI, Chesterton's Fence, Occam's Razor) on exact match; else raw distillation |
| [website-audit](skills/website-audit/SKILL.md) | SEO/AEO/GEO and structured-data audit. Playwright crawl, Lighthouse, Perplexity citation check, deterministic scoring |
| [interactive-qa](skills/interactive-qa/SKILL.md) | Q&A that collects your decisions when agents present options or disagree. Plain-language choices, recommendation flagged, dissent surfaced. Output briefs Plan Mode, an agent, or context |

## Install

```bash
ln -s /path/to/skills-gc/skills/verify ~/.claude/skills/verify
```

Each skill directory has a `SKILL.md` with the full definition and an `evals/` folder with test cases.

## License

MIT
