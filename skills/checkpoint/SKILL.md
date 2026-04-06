---
name: checkpoint
description: "End-of-session handoff that creates exactly one rich, narrative git commit describing what happened in the session — empty commit if no files changed, regular commit if there are changes. The commit body is the handoff: a long, specific, editorial description of what was done so the next session can read `git log` and understand the full history without context. Use this whenever the user signals end-of-session intent: 'checkpoint', 'checkpoint and commit', 'commit my work', 'wrap up', 'wrap up and commit', 'save session', 'save progress', 'end of session', 'log this session', 'end session', 'I'm done for today/the day/the night', 'closing up', 'pause for now', 'stash this', 'snapshot', or any phrasing that suggests they want a clean stopping point with a record of what was done. Pick this skill for any save/wrap-up/handoff action, even if the user does not say the word 'commit' explicitly."
---

# Checkpoint

One job: write a single git commit whose body is a rich, narrative record of what happened in this session. The next session — a fresh Claude with zero conversation history — must be able to read the commit body and fully understand what was tried, what was found, what was decided, and what state things are in.

That's it. No JSON files, no SUMMARY.md, no parallel logs. **Git log is the source of truth.** If a session changed code, the body explains the diff. If a session was pure investigation, debugging, or research, the body still gets written — as an empty commit (`git commit --allow-empty`) — because the *thinking* is the work and the next session needs it.

## Migrating from an older version

If this project has `logs/*_checkpoint.json` files from a previous version of this skill (the one that wrote parallel JSON files), run the migration script once before your first checkpoint with the new skill:

```bash
python3 skills/checkpoint/scripts/migrate-checkpoints-to-git.py
```

It builds a single backfill commit body that imports every legacy checkpoint into a long-form git commit, then prints the exact `git commit --allow-empty -F …` line for you to run. After committing, you can delete `logs/`. The migration script never commits on your behalf — it only drafts the body and tells you what to run.

## Hard rules

These exist because each one prevents a specific, painful failure mode. Don't bend them.

- **Never push.** Local commit only. The user pushes when ready.
- **Never `--amend`.** Always a new commit. Amend rewrites history; new commits preserve it and squash trivially later.
- **Never `--no-verify` or `--no-gpg-sign`.** A failing pre-commit hook found a real problem. Fix the cause, re-stage, create a new commit.
- **Never `git add -A`, `git add .`, or `git add -u`.** Pass each path explicitly. Global staging is the #1 way junk and secrets get committed by accident.
- **Never stage secrets.** Skip `.env*` (except `.env.example` / `.env.sample` / `.env.template`), `*credentials*`, `*secret*`, `*.key`, `*.pem`, `id_rsa*`, `id_ed25519*`, `*.ppk`. If one appears in the diff, stop and ask.

---

## Phase 1 — Gather context

Run in parallel:

- `git rev-parse --is-inside-work-tree 2>/dev/null` — is this a git repo?
- `git branch --show-current`
- `git log -10 --format="%h %s%n%b%n---"` — recent commits, for style matching AND so you know what the *previous* sessions looked like
- `git status --short`
- `git diff --stat HEAD`
- `git diff HEAD` — read the **full diff**. You cannot write a body that explains *why* without first understanding *what* changed.
- `ls .git/MERGE_HEAD 2>/dev/null` — merge in progress?
- `date '+%Y-%m-%d %H:%M'`

**Not a git repo?** This skill needs git. Tell the user: *"This directory isn't a git repo. Want me to run `git init` so we can capture the session, or skip the commit?"* Wait for their answer. Don't auto-init.

**Merge in progress?** Don't commit anything. Tell the user the merge is unresolved and they need to finish it manually. You can still do nothing else — there is no useful commit to make in this state.

---

## Phase 2 — Decide the commit type

From `git status --short`:

| State | Action |
|---|---|
| Files changed (modified, added, deleted) | **Regular commit** with the changed files staged |
| Working tree clean (empty `git status`) | **Empty commit** via `git commit --allow-empty` — the body is the entire point |
| Only untracked files that look like cruft (build artefacts, `.DS_Store`, editor swap files) | **Empty commit** — don't sweep junk into a session record |

Empty commits are not a workaround — they are the design. A debugging session that finds a root cause but writes no code is *real work*, and it deserves a real entry in the project history. The body is the deliverable.

---

## Phase 3 — Safety scan (only if there are files to stage)

Skip this phase entirely if Phase 2 decided on an empty commit.

Scan the list of changed and untracked files against these patterns:

- `.env`, `.env.*` — except `.env.example`, `.env.sample`, `.env.template`
- `*credentials*`, `*secret*`
- `*.key`, `*.pem`
- `id_rsa*`, `id_ed25519*`, `*.ppk`
- Any single file > 5 MB (warn, don't block)

Also scan the **diff content** for obvious secret shapes: AWS keys (`AKIA…`), Stripe keys (`sk_live_…`), `BEGIN PRIVATE KEY` blocks, OpenSSH private key blocks, long random hex strings in `.env`-shaped files. Diff-content scanning is a heuristic — err on the side of stopping.

If any **blocking** match is found:

1. Stop. Do not run `git add` yet.
2. Tell the user exactly which file(s) tripped the scan and what pattern matched.
3. Ask: exclude them from the commit, or abort entirely.
4. Wait for their answer.

If you exclude a sensitive file, also add it to `.gitignore` in the same commit so it can't be re-staged accidentally next time.

---

## Phase 4 — Set up the SessionStart hook (one-time, only if missing)

**Skip this phase entirely in either of these cases:**

- `.claude/settings.json` already has a SessionStart hook that runs `git log` on startup, OR
- Phase 2 decided on an empty commit (clean working tree). Scaffolding is real work that creates a real diff — bundling it into what should be a clean investigation commit would corrupt the empty-commit semantics. Defer scaffolding to the next session that has actual changes to bundle it with. A clean tree should stay clean.

If neither skip condition applies, the whole point of this skill is that future sessions can read the commit history on startup, and that requires a hook. Check for it:

```bash
test -f .claude/settings.json && grep -q 'git log' .claude/settings.json
```

If the file is missing or the grep fails, create or merge in:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "git log -5 --format='%h %ad%n%s%n%n%b%n---' --date=short 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

**If `.claude/settings.json` already exists with other content**, merge carefully: append to the existing `SessionStart` array, don't replace it. Never remove existing entries.

If you create or modify `.claude/settings.json` and there are real session changes, add it to the stage list in Phase 5 so it lands in the same commit as the session work.

---

## Phase 5 — Write the commit body

This is the heart of the skill. The body is a handoff letter to a fresh Claude who will read it tomorrow with zero memory of this conversation. Write it for that reader.

### Subject line

- **≤ 72 characters. This is a hard rule, not a soft guideline.** Count the characters before committing. If your draft is over 72, rewrite it shorter — do not commit a longer subject and rationalise the override. Concision is part of the design: `git log --oneline` and most review tools truncate around 72 columns, and a subject of the right length is always reachable with a small word swap or by moving detail into the body. Start over rather than ship long.
- No trailing period.
- Imperative verb first: `Add`, `Fix`, `Wire`, `Refactor`, `Investigate`, `Debug`, `Research`, `Document`.
- For empty commits (investigation, research): use a verb that signals it — `Investigate`, `Trace`, `Diagnose`, `Research`, `Document findings on…`
- Match the repo's style from `git log -10`: imperative vs past tense, conventional-commits prefixes (`feat:`, `fix:`) if used, sentence case vs lowercase. If the repo uses a convention, follow it. If it doesn't, don't invent one.

**Good subjects:**
- `Wire JWT refresh endpoint and extract token validation middleware`
- `Investigate Monday API latency spike — root cause in auth middleware`
- `Debug eval-viewer crash on missing benchmark stddev`
- `Research empty-commit pattern for session handoffs`

**Bad subjects:**
- `Updates`, `WIP`, `checkpoint`, `end of session` — say nothing
- `Fixed bug` — which bug? what was the fix?
- `Added new feature for user authentication system using JWT refresh tokens for longer sessions` — too long; details belong in the body

### Body structure

Use this template. **Omit sections that have no content** — empty headings are noise.

```
## Summary
<2-3 sentences. What was the user trying to accomplish, and what's the headline outcome of this session? Concrete, not generic.>

## What happened
<The narrative. Multiple paragraphs. Walk through the session in roughly the order things happened: what was the starting point, what was tried, what worked, what didn't, why we changed direction, what we settled on. Be specific — file names, function names, line numbers, error messages, library versions, exact commands. This is the section that does the heavy lifting for the next session.>

## Findings
<Only if the session produced concrete discoveries. Each finding should name where it lives in the code or in the system: "src/middleware/auth.ts line 23 — validateSession() runs a DB query on every request instead of checking the session cache first".>

## Decisions
<Only if real decisions were made. Format: "<decision>: <reason>". Example: "Use empty commits for no-code sessions: keeps git log as the single source of truth and avoids parallel JSON files.">

## Files touched
<Only if files were changed. One bullet per file, with what changed and *why*. The diff already shows what — the body explains why. Example:
- src/routes/auth.ts: added /refresh handler that swaps the access token using a refresh token. Needed because the current 15-minute access token forces re-login during long uploads.
- src/middleware/jwt.ts: new file. Extracted token validation out of routes/auth.ts so the new /refresh handler can reuse it without circular imports.>

## State
<Only if work is partial. Three sub-bullets:
- Done: <what's complete and verified>
- In progress: <what's half-wired, where it lives, what's missing — with line numbers>
- Blocked: <what can't proceed and exactly why>>

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>
```

Wrap body lines at ~72 characters. Match the repo's existing co-author trailer format if there is one — read the last few commits via `git log -5 --format="%b"` to see.

### Editorial principles

These are what separates a body that works from a body that doesn't.

1. **Write for a Claude who knows nothing about this conversation.** They have the diff and the commit history. They do not have the user's intent, your reasoning, the things you tried that didn't work, or the user's preferences. Spell it out.

2. **Be concrete.** Names, numbers, paths, errors, versions. Not "updated the auth middleware" — instead "added a `cache.get(sessionId)` check at the top of `validateSession()` in `src/middleware/auth.ts:23` so it stops hitting Postgres on every request."

3. **Preserve the user's exact references.** If the user said "around line 23" and you found the function at line 12, write both: `line 12 (user said "around line 23")`. Honour their mental model while protecting against drift.

4. **Narrative beats bullet soup.** "We started by trying X because Y; that broke when Z, so we switched to W and that worked" reads better than six disconnected bullets. Use bullets for genuine lists (files touched, findings), not as a substitute for sentences.

5. **Don't fabricate a clean story.** If the session was a meandering debug that ended in confusion, write that. If you tried three things and only one worked, mention all three. The next session benefits from knowing what doesn't work, not just what does.

6. **Empty commits get the same care as code commits.** A 30-word stub for a 2-hour debugging session wastes the work. If anything, empty commits need *more* body, because there is no diff backing them up.

7. **Don't pad.** Long is not the goal — *complete* is the goal. If the session was actually trivial ("bumped the version number"), the body can be one paragraph. If the session was substantive, the body needs to reflect that.

### Example: rich body for a code session

```
Wire JWT refresh endpoint and extract token validation middleware

## Summary
Wired up the missing /api/refresh endpoint so users can swap an
expired access token for a new one without re-logging in. Token
validation is now reusable across routes via a new middleware module.

## What happened
We started in src/routes/auth.ts where the access token issuing
already worked but there was no way to refresh it. The naive fix —
inline the validation logic in a new route handler — would have
duplicated the JWT verify code that already lives in the login
handler. So we extracted it first.

The extraction itself was awkward because routes/auth.ts imports
from src/lib/db.ts, and we initially put the new middleware in
src/lib/jwt.ts, which created a circular import (db -> jwt -> db).
Moved it to src/middleware/jwt.ts instead, which is on the right
side of the dependency graph.

With the middleware in place, /api/refresh became a 12-line handler:
verify the refresh token, check it isn't revoked (revocation list
lookup is a TODO — see State below), issue a new access token, return.
README updated with one line in the API section.

## Files touched
- src/routes/auth.ts: added the /api/refresh route handler. Uses
  the new middleware for verification. ~15 lines.
- src/middleware/jwt.ts: new file. Pulls JWT verification out of
  routes/auth.ts so multiple handlers can reuse it. ~30 lines.
- README.md: one-line addition to the API section noting the new
  /api/refresh endpoint.

## State
- Done: refresh endpoint works end-to-end against a fresh token.
- In progress: revocation check is stubbed (src/middleware/jwt.ts
  line 41, `// TODO: check revocation list`). The actual revocation
  store doesn't exist yet — needs a Redis set or a DB table.
- Blocked: nothing.

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>
```

### Example: rich body for a no-code investigation (empty commit)

```
Investigate Monday API latency spike — root cause in auth middleware

## Summary
Traced the post-deploy API latency spike to the new auth middleware
running a Postgres query on every request instead of checking the
session cache first. No code changes yet — confirming the diagnosis
before fixing it tomorrow.

## What happened
Started from the Datadog alert showing p95 latency went from 80ms
to 410ms after Monday's 14:20 deploy. Walked the diff between the
deploy SHA (a3f12b1) and the previous prod SHA (19c8e44). The only
auth-related change was the new validateSession() function in
src/middleware/auth.ts.

Reading validateSession() top-to-bottom, the issue is at line 23:
it calls `db.sessions.findById(sessionId)` directly, with no cache
check above it. The previous middleware did `cache.get(sessionId)`
first and only fell through to the DB on a miss. The cache lookup
was lost in the rewrite.

Verified by tailing the Postgres slow query log during a test run:
sessions.findById appears once per request, ~30ms each. That accounts
for the entire latency delta.

Did not write the fix — wanted to confirm with the user before
touching auth code.

## Findings
- src/middleware/auth.ts line 23: validateSession() calls
  db.sessions.findById on every request. The pre-rewrite version
  checked the session cache first; that check was dropped.
- Postgres slow query log confirms ~30ms per call, matching the
  observed latency delta.
- The session cache module (src/lib/session-cache.ts) is still
  imported elsewhere, so the cache infrastructure is fine — only
  the lookup was removed.

## Decisions
- Confirm root cause before fixing: auth middleware is sensitive
  and the user wanted to sign off on the approach before any edit.

## State
- Done: root cause confirmed and reproduced.
- In progress: nothing — clean working tree.
- Blocked: needs user sign-off on the fix approach (add cache.get
  check at top of validateSession, fall through to db on miss).

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>
```

---

## Phase 6 — Stage and commit

### Build the explicit stage list

For a regular commit:

1. Start with everything in `git status --short`.
2. Remove anything the safety scan excluded.
3. Add any scaffolding files Phase 4 created (`.claude/settings.json`, possibly `.gitignore`).
4. Pass each path explicitly to `git add`. Never `-A`, never `.`, never `-u`.

For an empty commit, skip the staging step entirely.

### Create the commit

Pass the message via heredoc so multi-line bodies survive intact:

```bash
git add <path1> <path2> <path3>   # omitted for empty commits
git commit [--allow-empty] -m "$(cat <<'EOF'
<subject line>

## Summary
...

## What happened
...

(rest of body)

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>
EOF
)"
```

Then run `git status` and `git log -1 --format="%h %s"` to confirm the commit landed and capture the new short hash.

### Pre-commit hook failure

If `git commit` fails because a pre-commit hook rejected the change:

1. **Read the hook output carefully.** Understand exactly what failed — formatter, linter, type check, tests, custom check. The hook output is your only source of truth here.
2. **Formatter auto-rewrote files** (e.g. prettier, black, gofmt): the files on disk are now fixed. Re-stage them and create a new commit with the same message.
3. **Linter or check found a clear, narrow issue you can fix** (trailing whitespace, missing semicolon, unused import, simple type error): make the fix in the source file, re-stage the now-fixed file, create a new commit. Same message — the underlying intent didn't change, only the formatting/cleanup did.
4. **Issue is real but out of scope** (failing tests for unrelated code, type errors that need a refactor, secrets the user actually wants to commit, anything that needs human judgement): do NOT commit. Leave the changes staged so the user can decide. Print a clear report:
   - what the hook failure was, verbatim
   - what you tried (if anything)
   - exactly what the user needs to do next
   - the staged file list, untouched

   Do not try to sneak around the hook with an empty commit — pre-commit hooks run on empty commits too, and even if they didn't, hiding the failure from git would defeat the point of the hook.

**Never `--no-verify`.** Hooks find real problems. The cost of bypassing one is invisible until something breaks in production. **Never `--amend`** — failed commits don't create a commit to amend, and even if they did, a new commit is safer.

---

## Phase 7 — Confirm

Print, in this order:

1. `Committed: <short-hash> <subject>` — or `No commit: <reason>` if blocked
2. `Type: regular | empty (no diff)`
3. One-line summary of the body's headline
4. `Not pushed. Run 'git push' when ready.`

Keep it five lines or fewer. The user can read the commit themselves; don't restate the body.

---

## Why this design

A previous version of this skill split the work across two parallel systems: a JSON checkpoint in `logs/`, plus a git commit. That sounds thorough but creates real problems:

- **Two sources of truth drift apart.** The checkpoint and the commit body almost always overlap, and the moment they diverge, the next session has to guess which one to trust.
- **Investigation sessions fall through the cracks.** A pure-research session produces no diff, so the commit-side mechanism does nothing — and if a future hook ever changes to read git, that work disappears entirely.
- **Forward-looking "next steps" rot fast.** A `next_steps` field written at session end becomes stale within minutes once the user starts the next session and the situation moves on. The historical record of what was *done* doesn't rot — it's true forever.

The fix is one mechanism: every session ends in exactly one commit. Code session → regular commit. No-code session → empty commit. Either way, the body is a complete handoff letter, and `git log` is the only place to look. The SessionStart hook reads the last 5 commits on startup and the next session has full context with zero parsing.

The safety rails (no push, no amend, explicit paths, secret scan) exist because each one prevents a specific way people get burned, and the loss from skipping any of them is much greater than the cost of following them.
