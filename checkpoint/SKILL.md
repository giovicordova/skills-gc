---
name: checkpoint
description: "End-of-session handoff log. Analyses the current session and writes a structured checkpoint to logs/ so the next session can pick up with full context. Use when the user says 'checkpoint', 'end of session', 'save session', 'wrap up', 'save progress', or is about to close the terminal. Also use when context is getting long and a handoff would help continuity."
argument-hint: "[optional summary note]"
---

# Checkpoint

Write a structured session handoff to `logs/` so the next Claude Code session can cold-start with full context. The checkpoint is a briefing document — written for a version of yourself that knows nothing about this session.

## Why this matters

Claude Code sessions are ephemeral. Without a checkpoint, the next session starts blind — the user has to re-explain everything, decisions get lost, half-finished work gets forgotten. A good checkpoint eliminates that friction entirely.

## How to analyse the session

Before writing anything, review what actually happened:

- **Tools you used** — which files were read, written, edited? That tells you what changed.
- **User corrections** — anywhere the user redirected you. Those are decisions worth recording.
- **Unfinished threads** — tasks started but not completed, things mentioned but not reached.
- **Blockers** — errors, missing dependencies, unresolved questions.

Be accurate. If you're unsure whether something was resolved, say so. Don't fabricate a clean narrative.

## Steps

### 1. Gather context

Run `git rev-parse --is-inside-work-tree 2>/dev/null`.

- **If git repo:** run `git branch --show-current`, `git log --oneline -5`, `git status --short`, and `git diff --stat HEAD`.
- **If not a git repo:** skip all git commands and omit Git state from the checkpoint.

Get the timestamp: `date '+%Y-%m-%d_%H-%M'`

### 2. Write the checkpoint

Create `logs/` if needed (`mkdir -p logs`). Write to `logs/YYYY-MM-DD_HH-MM_checkpoint.md`.

**Required sections** (always include):

```markdown
---
date: YYYY-MM-DD HH:MM
project: <basename of working directory>
branch: <current git branch or "n/a">
---

# Checkpoint: <$ARGUMENTS if provided, otherwise one-line session summary>

## What happened
<2-3 sentences. What was the user trying to accomplish? How far did we get?>

## Next steps
1. <most important action — specific enough for a cold-start Claude to execute>
2. <second action>
3. <third action>
```

**Optional sections** (include only when they have content worth recording):

```markdown
## What changed
- <file or area>: <what and why>

## Key findings
- <important discovery or learning from the session>

## Decisions made
- <decision>: <rationale>

## Current state
- **Done:** <what is complete>
- **In progress:** <what is partial, how far along>
- **Blocked:** <what can't proceed and why>

## Git state
- **Branch:** <name>
- **Last commit:** <hash + message>
- **Uncommitted changes:** <summary or "none">
```

### Choosing the right sections

The template adapts to the session type:

- **Coding session** (files changed): include What changed, Current state, Git state
- **Investigation/debugging** (no code changes): skip What changed entirely — don't write "nothing changed." Include Key findings with the root cause or discovery.
- **Informational/learning session**: skip What changed and Decisions. Use Key findings for what was learned. Keep it lean.
- **Simple session**: What happened + Next steps might be all you need.

### Writing rules

**Be specific.** File names, function names, line numbers, error messages. Not "updated the config" — instead "added `SESSION_TIMEOUT=3600` to `.env` because the default 300s was too short for long uploads."

**Next steps is the most important section.** Write it as instructions to yourself starting completely fresh. Bad: "Continue working on auth." Good: "Wire up the `/api/refresh` endpoint in `src/routes/auth.ts` — the token validation logic is done but the route handler isn't registered in the Express router yet (see line 45)."

### 3. One-time setup (skip if already done)

These steps only need to happen once per project. Check first, skip if already configured.

**Gitignore:** If git repo, ensure `.gitignore` contains `logs/`. Create the file if needed. Don't touch existing entries.

**SessionStart hook:** Check `.claude/settings.json` at the project root. If a hook referencing `logs/` already exists (`grep -q 'logs/' .claude/settings.json 2>/dev/null`), skip. Otherwise, add:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "f=$(ls -1 logs/*.md 2>/dev/null | sort -r | head -1); [ -n \"$f\" ] && cat \"$f\""
          }
        ]
      }
    ]
  }
}
```

If `settings.json` already has content, merge carefully — append to existing `SessionStart` array or add alongside other keys. Never remove existing entries.

### 4. Confirm

Print:
- `Checkpoint saved: logs/<filename>`
- The checkpoint heading
- The first next step
