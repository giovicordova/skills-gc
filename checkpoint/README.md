# checkpoint

End-of-session handoff log. Analyses what happened in the current session and writes a structured checkpoint to `logs/` so the next session can pick up with full context.

Adapts format to session type — coding sessions get file diffs and git state, investigations get root cause findings, learning sessions stay lean.

## Triggers

`checkpoint`, `end of session`, `save session`, `wrap up`, `save progress`

## How it works

1. Reviews tools used, user corrections, unfinished threads, and blockers from the session
2. Gathers git state (branch, recent commits, uncommitted changes)
3. Writes a timestamped markdown file to `logs/`
4. Sets up a SessionStart hook so the next session auto-loads the latest checkpoint

The checkpoint adapts its sections to the session type — no empty boilerplate. Investigation sessions get Key findings instead of What changed. Learning sessions stay lean.

## Structure

```
checkpoint/
  SKILL.md          # Skill definition
  evals/
    evals.json      # 3 eval cases (coding, investigation, learning sessions)
```
