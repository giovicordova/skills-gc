# skills-gc

Custom skills for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) — the CLI tool from Anthropic.

Each skill is a self-contained markdown file that gives Claude specific behaviours when invoked. They work like slash commands: type `/checkpoint` and Claude follows the skill instructions instead of improvising.

## Skills

### checkpoint

End-of-session handoff log. Analyses what happened in the current session and writes a structured checkpoint to `logs/` so the next session can pick up with full context. Adapts format to session type — coding sessions get file diffs and git state, investigations get root cause findings, learning sessions stay lean.

**Triggers:** `checkpoint`, `end of session`, `save session`, `wrap up`, `save progress`

### verify

Audits Claude's own output against the user's original request. Extracts every requirement (explicit and implicit), compares each against what was actually delivered, and flags gaps, drift, and scope creep. Produces a structured compliance report with PASS/PARTIAL/FAIL verdicts and specific evidence.

**Triggers:** `verify`, `check your work`, `did you follow my request`, `audit this`

### plan-challenger

Stress-tests implementation plans before execution. Researches alternatives (searches for existing libraries, checks docs), challenges complexity across 8 dimensions (goal alignment, simplification, risk, over-engineering, ordering, etc.), then delivers a complete revised plan ready to execute.

**Triggers:** `challenge this plan`, `review this plan`, `stress test`, `is this plan good`

## Structure

Each skill directory contains:

```
skill-name/
  SKILL.md          # The skill definition (frontmatter + instructions)
  evals/
    evals.json      # Test cases for measuring skill quality
    files/           # Supporting files for evals (optional)
  workspace/         # Eval run results — with/without skill comparisons (optional)
```

## Installation

Clone this repo and symlink the skills you want into your Claude Code skills directory:

```bash
# Link a single skill
ln -s /path/to/skills-gc/checkpoint ~/.claude/skills/checkpoint

# Or link all of them
for skill in checkpoint verify plan-challenger; do
  ln -s /path/to/skills-gc/$skill ~/.claude/skills/$skill
done
```

Skills are picked up automatically by Claude Code on the next session.

## Evals

Each skill includes eval cases in `evals/evals.json`. These define prompts, expected outputs, and specific expectations to measure whether the skill produces the right behaviour. They can be run with the [skill-creator](https://github.com/nichochar/skill-creator) eval framework.

The `verify` skill also includes a `workspace/` directory with full eval run results — iterations comparing output with and without the skill, including grading, timing, and generated artefacts.

## License

MIT
