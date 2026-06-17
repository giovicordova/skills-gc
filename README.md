# skills-gc

Custom skills for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Triggered from context or as slash commands.

| Skill | What it does |
|-------|-------------|
| [wrap](skills/wrap/SKILL.md) | `/wrap` end-of-session: saves signal to auto-memory, commits with session narrative, pushes |
| [verify](skills/verify/SKILL.md) | Audits output vs. request: PASS/PARTIAL/FAIL per requirement, flags scope creep |
| [plan-challenger](skills/plan-challenger/SKILL.md) | Stress-tests plans pre-execution: researches alternatives, returns revised plan |
| [perspective](skills/perspective/SKILL.md) | Reality check vs. live docs: does the solution exist, is there a better path |
| [cc-audit](skills/cc-audit/SKILL.md) | Audits a project's Claude Code setup across 9 areas: scored AUDIT-REPORT.md |
| [coherency-check](skills/coherency-check/SKILL.md) | Finds contradictions across docs/code; resolves each interactively |
| [philosophier](skills/philosophier/SKILL.md) | Compresses text to shortest precise phrasing; cites principles (YAGNI, Occam) on match |
| [website-audit](skills/website-audit/SKILL.md) | SEO/AEO/GEO and structured-data audit: Playwright, Lighthouse, Perplexity citations |
| [interactive-qa](skills/interactive-qa/SKILL.md) | Q&A to collect your decisions when agents disagree; output briefs Plan Mode or agent |
| [auto-improve](skills/auto-improve/SKILL.md) | Loop that incrementally improves a target (agent/skill/doc/folder): verifies external claims, tightens prose. Mode + interval chosen at start; findings reviewed via `/interactive-qa` after |
| [cut](skills/cut/SKILL.md) | `/cut` forces a concise reply with no loss of substance — redoes Claude's last wall, or answers a new question short upfront — then holds short mode for the session |
| [prompt](skills/prompt/SKILL.md) | `/prompt` rewrites your rough spoken-style ask into a structured prompt — interprets faithfully, never invents; closes real gaps via `interactive-qa` — then executes it |
## Install
```bash
ln -s /path/to/skills-gc/skills/verify ~/.claude/skills/verify
```
Each skill has `SKILL.md` (definition) and `evals/` (tests). MIT.
