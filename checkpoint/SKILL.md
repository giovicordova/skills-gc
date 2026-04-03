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

Before writing anything, review what actually happened. Look at:

- **Tools you used** — which files were read, written, edited? That's your "what changed" section.
- **User corrections** — anywhere the user said "no", "not that", or redirected you. These are decisions worth recording.
- **Unfinished threads** — tasks you started but didn't complete, or things the user mentioned but you didn't get to.
- **Blockers encountered** — errors, missing dependencies, questions you couldn't answer.

The goal is accuracy. If you're unsure whether something was resolved, say so. Don't fabricate a clean narrative.

## Steps

### 1. Check git state (if applicable)

Run `git rev-parse --is-inside-work-tree 2>/dev/null`.

- **If git repo:** run `git branch --show-current`, `git log --oneline -5`, `git status --short`, and `git diff --stat HEAD`.
- **If not a git repo:** skip all git commands. Set branch to `n/a` and omit the Git state section entirely.

### 2. Write the checkpoint

Get the timestamp: `date '+%Y-%m-%d_%H-%M'`

Create the directory if needed: `mkdir -p logs`

Write to `logs/YYYY-MM-DD_HH-MM_checkpoint.md` using this structure:

```markdown
---
date: YYYY-MM-DD HH:MM
project: <basename of working directory>
branch: <current git branch or "n/a">
---

# Checkpoint: <$ARGUMENTS if provided, otherwise one-line session summary>

## What happened
<2-3 sentences framing the session. What was the user trying to accomplish? How far did we get?>

## What changed
- <file or area>: <what changed and why>

## Decisions made
- <decision>: <why we chose this over alternatives>

## Current state
- **Done:** <what is fully complete>
- **In progress:** <what is partially done, and how far along>
- **Blocked:** <what can't proceed and why>

## Next steps
1. <most important next action — be specific enough that a cold-start Claude can execute it>
2. <second action>
3. <third action>

## Git state
- **Branch:** <branch name>
- **Last commit:** <short hash + message>
- **Uncommitted changes:** <summary or "none">
```

### Writing rules

**Be specific.** File names, function names, line numbers, error messages. Not "updated the config" — instead "added `SESSION_TIMEOUT=3600` to `.env` because the default 300s was too short for long uploads."

**Next steps is the most important section.** Write it as instructions to yourself starting completely fresh. Include enough context that the action is unambiguous. Bad: "Continue working on auth." Good: "Wire up the `/api/refresh` endpoint in `src/routes/auth.ts` — the token validation logic is done but the route handler isn't registered in the Express router yet (see line 45)."

**Omit empty sections.** The template is a maximum structure. If there were no decisions, no blockers, no open questions — drop those sections. A checkpoint for a simple session might only have What happened, What changed, and Next steps.

**Omit Git state** if this isn't a git repo.

### 3. Gitignore logs/

If this is a git repo, ensure `.gitignore` contains a `logs/` entry. Create `.gitignore` if it doesn't exist. Don't touch existing entries.

### 4. Set up auto-injection for next session

The checkpoint is only useful if the next session actually sees it. Set up a SessionStart hook that automatically feeds the latest checkpoint into context.

Check `.claude/settings.json` at the project root. If a `SessionStart` hook referencing `logs/` already exists (`grep -q 'logs/' .claude/settings.json 2>/dev/null`), skip this step.

Otherwise, add this hook configuration:

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

If `.claude/settings.json` already exists with other content:
- If a `SessionStart` key exists, append to the existing array.
- If no `SessionStart` key, add it alongside existing keys.
- Never modify or remove existing entries.

### 5. Confirm

Print:
- `Checkpoint saved: logs/<filename>`
- The checkpoint heading
- The first next step
