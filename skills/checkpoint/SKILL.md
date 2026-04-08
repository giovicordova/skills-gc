---
name: checkpoint
description: End-of-session handoff and start-of-session recall. Use when the user types /checkpoint or signals they're wrapping up — writes a single git commit (subject = one-sentence summary, body = full narrative) and appends the same sentence to CHECKPOINTS.md. ALSO use at the start of a fresh session when the user references prior work ("where were we", "continue", "the thing from yesterday", or any reference to a past decision, file, or investigation the current session hasn't seen) — read CHECKPOINTS.md first, then fetch full commit bodies only for sessions that match.
---

# Checkpoint

Each session leaves two things behind:

1. **One line in `CHECKPOINTS.md`** — the cheap read. Next session scans this first to see the shape of recent history.
2. **A git commit** — the full story. Subject = the same one-sentence summary. Body = what was done, where, what decisions were taken, what didn't work.

The index is the map; the commit is the territory. Fresh sessions read the map first and open the territory only when something looks relevant.

Why git, not files in a folder? Commits are persistent, synced across machines via the remote, visible to collaborators, and free. No parallel filesystem to keep in sync.

---

## Writing a checkpoint

**When.** On `/checkpoint`, or when the user signals wrap-up ("we're done", "I'll /clear now"). Never volunteer unprompted — the user decides when to draw the line.

Write even when no files changed. A pure investigation is still real work, and the next session benefits from knowing what was ruled out. `CHECKPOINTS.md` will always be part of the diff, so the commit is rarely truly empty.

### Step 1 — Gather

Reconstruct the session from memory and git:

- `git status` — what's staged, unstaged, untracked
- `git diff --stat HEAD` — shape of the changes
- Your own recall — what was asked, tried, failed, decided

Pay attention to what the diff won't show: alternatives considered, dead ends, the reasoning behind a choice. Code can't reconstruct this. That's the part worth writing down.

### Step 2 — Write the one-sentence title

One sentence. Past tense. Specific enough that the next session can tell what changed without opening the body.

**Good:**
- `Rebuilt checkpoint skill as v2 with index-based retrieval and long-form git commits.`
- `Traced the staging logout bug to a cookie domain mismatch in nginx — no code change, fix planned for Monday.`

**Bad:**
- `Updates` — meaningless.
- `checkpoint: sort fix + colour filter` — not a sentence, tag-prefixed, breaks retrieval.
- `Worked on the auth stuff` — vague, past-Claude could have done anything.

This exact sentence goes in two places that must match character-for-character: the commit subject, and a new line in `CHECKPOINTS.md`. Retrieval uses `git log --grep="<exact title>"`, so any drift breaks the join.

### Step 3 — Write the body

The body is the detailed record the next session opens only when it needs to. Cover, in natural prose:

- What was done, in order
- Where — directories, files, configs, external systems
- What was tried and rejected, with reasoning
- Decisions taken, with reasoning
- State at end of session — what's done, what's in flight, what to pick up next

**Length is proportional to the session.** A 15-minute fix gets a short body. A 3-hour investigation with three dead ends gets a long one. Don't pad to look thorough. Don't truncate what future-you will actually need. A good rule: if you deleted a sentence from the body, would the next session miss something important? If no, delete it.

### Step 4 — Append to CHECKPOINTS.md

If `CHECKPOINTS.md` doesn't exist yet, create it with:

```markdown
# Checkpoints

One-sentence summary per session, newest first. For the full story of a
session, run: `git log --all --grep="<the exact title>" -1`
```

Then prepend under the header (newest first):

```
- YYYY-MM-DD — <the exact one-sentence title>
```

### Step 5 — Stage and commit

Sanity-check for secrets before staging. No `.env`, keys, credentials, private keys. If `.gitignore` is missing obvious entries, flag it to the user before committing.

Subject must match the CHECKPOINTS.md entry exactly. Use `-F` with the subject on line 1 and the body below — this avoids the `-m + -F` conflict:

```bash
# write subject + blank line + body to /tmp/checkpoint-msg.txt, then:
git add CHECKPOINTS.md <other files>
git commit -F /tmp/checkpoint-msg.txt
```

Never use `--no-verify`. If a pre-commit hook fails, read the error, fix the root cause, re-stage, new commit.

---

## Reading past checkpoints

Trigger when the first message of a fresh session references prior work — "where were we", "continue", "the thing from yesterday", or any reference to a decision or file the current session hasn't seen.

1. Read `CHECKPOINTS.md`. Each line is one sentence, dated.
2. Match the user's request to recent titles **semantically** — "the auth thing" should match a title about cookies or sessions even if "auth" never appears. Usually the top 1–3 entries are enough.
3. For each match, fetch the full body:
   ```bash
   git log --all --grep="<the exact title>" -1 --format=%B
   ```
4. Summarise back to the user in 2–3 lines before making any changes. Gives them a chance to correct you cheaply.

---

## Loading the index automatically

Add one line to the project's `CLAUDE.md` so fresh sessions see recent history without asking:

```
@CHECKPOINTS.md
```

The index is small (one sentence per session). Full commit bodies stay on disk until needed.

---

## What this is NOT

- **Not a replacement for Claude Code memory.** Memory holds durable facts (who the user is, project constraints). Checkpoint holds the story of each specific session. They complement each other.
- **Not a changelog.** A changelog is for shipped work. A checkpoint includes dead ends, pure investigations, decisions not to act.
- **Not a todo list.** Follow-up work goes in the "state at end of session" paragraph, not as a tracked task.
