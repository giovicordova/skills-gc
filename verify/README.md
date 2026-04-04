# verify

Audits Claude's own output against the user's original request — did Claude do exactly what was asked, no more, no less?

Extracts every requirement (explicit and implicit), compares each against what was delivered, and flags gaps, drift, and scope creep. Produces a structured compliance report with PASS/PARTIAL/FAIL verdicts and specific evidence.

## Triggers

`verify`, `check your work`, `did you follow my request`, `audit this`, `compliance check`

## How it works

1. Extracts every concrete requirement from the session — explicit instructions and implicit constraints (e.g. "simple" means don't over-engineer)
2. Reads every file Claude wrote or edited in the session
3. Compares requirement by requirement with PASS/PARTIAL/FAIL verdicts and line-number evidence
4. Scans for unrequested additions and rates severity (harmless, scope creep, harmful)
5. Offers to fix any PARTIAL or FAIL items

Clean results get a one-liner. Problems get the full table.

## Structure

```
verify/
  SKILL.md          # Skill definition
  evals/
    evals.json      # 3 eval cases (full compliance, partial, scope creep)
  workspace/        # Eval run results — with/without skill comparisons across iterations
```
