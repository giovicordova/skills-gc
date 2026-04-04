---
name: checkpoint
description: "End-of-session handoff log. Writes a JSON checkpoint + updates a rolling summary so future sessions can cold-start with full context. Use when the user says 'checkpoint', 'end of session', 'save session', 'wrap up', 'save progress', or is about to close the terminal. Also use when context is getting long and a handoff would help continuity."
argument-hint: "[optional summary note]"
---

# Checkpoint

Write a structured session handoff to `logs/` so the next Claude Code session can cold-start with full context. The checkpoint is a briefing document — written for a version of yourself that knows nothing about this session.

- **`logs/SUMMARY.md`** — rolling index, injected on every session start (~1 line per session, capped at 30 entries).
- **`logs/*_checkpoint.json`** — full structured checkpoints. Read the summary, decide which logs are relevant, pull them on demand.

Before writing, review the full session: tools used, user corrections, unfinished threads, blockers. Be accurate — don't fabricate a clean narrative.

## Steps

### 1. Gather context

Run `git rev-parse --is-inside-work-tree 2>/dev/null`.

- **If git repo:** run `git branch --show-current`, `git log --oneline -5`, `git status --short`, and `git diff --stat HEAD`.
- **If not a git repo:** skip all git commands and omit git fields from the checkpoint.

Get the timestamp: `date '+%Y-%m-%d_%H-%M'`

### 2. Write the JSON checkpoint

Create `logs/` if needed (`mkdir -p logs`). Write to `logs/YYYY-MM-DD_HH-MM_checkpoint.json`.

Omit optional fields that have no content — don't include them with empty arrays.

```json
{
  "date": "YYYY-MM-DD HH:MM",
  "project": "<basename of working directory>",
  "branch": "<current git branch or null>",
  "summary": "<$ARGUMENTS if provided, otherwise one-line session summary>",
  "what_happened": "<2-3 sentences. What was the user trying to accomplish? How far did we get?>",
  "next_steps": [
    "<most important action — specific enough for a cold-start Claude to execute>",
    "<second action>",
    "<third action>"
  ],

  "what_changed": ["<file or area>: <what and why>"],
  "findings": ["<important discovery or learning>"],
  "decisions": ["<decision>: <rationale>"],
  "state": {
    "done": ["<what is complete>"],
    "in_progress": ["<what is partial, how far along>"],
    "blocked": ["<what can't proceed and why>"]
  },
  "git": {
    "last_commit": "<hash + message>",
    "uncommitted": "<summary or null>"
  }
}
```

**Which optional fields to include:**

- **Coding session** (files changed): `what_changed`, `state`, `git`
- **Investigation/debugging** (no code changes): `findings` with root cause or discovery
- **Informational/learning**: `findings` for what was learned
- **Simple session**: required fields only

### Writing rules

**Be specific.** File names, function names, line numbers, error messages. Not "updated the config" — instead "added `SESSION_TIMEOUT=3600` to `.env` because the default 300s was too short for long uploads."

**`next_steps` is the most important field.** Write it as instructions to yourself starting completely fresh. Bad: "Continue working on auth." Good: "Wire up the `/api/refresh` endpoint in `src/routes/auth.ts` — the token validation logic is done but the route handler isn't registered in the Express router yet (see line 45)."

### 3. Update SUMMARY.md

Append one entry to `logs/SUMMARY.md`. Create the file if it doesn't exist.

Format — one line per session:

```
- **YYYY-MM-DD HH:MM** (<branch>) — <summary>. Next: <first next step, abbreviated>.
```

Keep each entry under 150 characters. **Cap at 30 entries** — if the file exceeds 30 lines, trim the oldest entries from the top.

### 4. One-time setup (skip if already done)

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
            "command": "cat logs/SUMMARY.md 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

If `settings.json` already has content, merge carefully — append to existing `SessionStart` array or add alongside other keys. Never remove existing entries.

### 5. Confirm

Print:
- `Checkpoint saved: logs/<filename>`
- The checkpoint summary line
- The first next step
