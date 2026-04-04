# plan-challenger

Stress-tests implementation plans before execution. Fixing a plan costs minutes. Fixing an implementation costs hours.

Researches alternatives (searches for existing libraries, checks docs), challenges complexity across 8 dimensions, then delivers a complete revised plan ready to execute.

## Triggers

`challenge this plan`, `review this plan`, `stress test`, `is this plan good`, `before we start`

## How it works

1. Reads the plan (any format — file, inline, pasted)
2. **Researches** — searches for existing libraries, checks docs, looks for prior art. This step is mandatory and what separates this from a generic review.
3. **Analyses across 8 dimensions** — goal alignment, simplification, modularity, risk, over-engineering, missing pieces, ordering, maintainability forecast
4. **Delivers a verdict** — READY, REVISE, or RETHINK — with grouped findings by severity and a complete revised plan

## Structure

```
plan-challenger/
  SKILL.md          # Skill definition
  evals/
    evals.json      # 4 eval cases (over-engineered, missing research, bad ordering, wrong consolidation)
    files/           # Sample plans used as eval inputs
```
