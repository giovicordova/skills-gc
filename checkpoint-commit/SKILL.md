---
name: checkpoint-commit
description: "End-of-session handoff that writes a checkpoint log AND creates a clean git commit of the session's work, in one step. Use when the user says 'checkpoint and commit', 'save and commit', 'wrap up and commit', 'commit my work', 'clean commit', 'end session with commit', 'stash and commit', or otherwise signals they want both a handoff log and a committed state before stopping. Accepts an optional one-line summary note as arguments. This is the commit-including variant of the plain checkpoint skill — pick this one whenever 'commit' appears alongside any wrap-up phrasing, even implicitly."
---

# Checkpoint + Commit

Two jobs, one flow:

1. **Handoff log** — structured checkpoint in `logs/` so the next session can cold-start with full context.
2. **Clean commit** — one well-scoped, well-messaged git commit of the session's work, created safely.

The checkpoint is written *before* the commit so that if the commit step has to bail (secret detected, nothing to commit, merge in progress, hook failure), the handoff log already exists and the next session still has full context.

## Hard rules

- **Never push.** Local commit only. The user pushes when they're ready.
- **Never `--no-verify`, never `--no-gpg-sign`.** If a pre-commit hook fails, fix the cause, re-stage, create a NEW commit.
- **Never amend.** Always a new commit. Amending rewrites history and loses work when the previous state was meaningful.
- **Never stage secrets.** Skip `.env*` (except `.env.example`/`.env.sample`), `*credentials*`, `*secret*`, `*.key`, `*.pem`, `id_rsa*`, `id_ed25519*`. If one appears in the diff, stop and ask — do not commit.
- **Never `git add -A` or `git add .`** — use explicit file paths. Surprises in global staging are the #1 way accidental junk gets committed.

These rules are non-negotiable because each one exists to prevent a specific, painful, hard-to-reverse failure mode.

---

## Phase 1 — Gather context

Run `git rev-parse --is-inside-work-tree 2>/dev/null`.

- **Not a git repo:** skip all commit steps. Do Phases 2, 5, and 6 (checkpoint + summary + confirm). In Phase 6, note "no commit — directory is not a git repo."
- **Git repo:** continue.

Run in parallel:
- `git branch --show-current`
- `git log --oneline -5`
- `git status --short`
- `git diff --stat HEAD`
- `git diff HEAD` — read the full diff. You need to understand what's about to be committed before you can write a message that explains *why*.

Timestamp: `date '+%Y-%m-%d_%H-%M'`

Check for merge in progress: `ls .git/MERGE_HEAD 2>/dev/null`. If it exists, a merge is unresolved — you'll skip the commit step later, but still write the checkpoint.

### While reading the diff, notice obvious issues

As you read the full diff, keep a light lookout for problems the user may not have flagged: imports of packages not in `package.json` / `requirements.txt` / `Cargo.toml`, unresolved `TODO` / `FIXME`, functions called but never defined, obvious off-by-ones, removed code that's still referenced elsewhere. You're not doing a full code review — just a quick scan. Surface what you find in `state.in_progress` or `findings` in the checkpoint so the next session picks it up. This is cheap and saves real time downstream.

---

## Phase 2 — Write the checkpoint JSON

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
    "last_commit": "<hash + message of the commit that existed BEFORE this skill ran>",
    "uncommitted": "<short description of what's about to be committed by this skill, or null if nothing>"
  }
}
```

`git.last_commit` is the *pre-commit* state — it's the commit this checkpoint picks up from. The new commit this skill creates will show up in the confirmation at the end and in the SUMMARY.md entry.

### Writing rules

**Be specific.** File names, function names, line numbers, error messages. Not "updated the config" — instead "added `SESSION_TIMEOUT=3600` to `.env` because the default 300s was too short for long uploads."

**Preserve the user's specific references.** If the user named a file, function, or line number in their message, carry those exact references into the checkpoint verbatim. If your own investigation found a different location (e.g., the user said "line 23" but the function is actually at line 12), write both: `line 12 (user said "around line 23")`. This protects against small factual drift while still honouring the user's original mental model.

**`next_steps` is the most important field.** Write it as instructions to yourself starting completely fresh. Bad: "Continue working on auth." Good: "Wire up the `/api/refresh` endpoint in `src/routes/auth.ts` — the token validation logic is done but the route handler isn't registered in the Express router yet (see line 45)."

**Omit empty fields — don't include them as empty arrays or nulls.** If `findings` has no entries, the key should not appear in the JSON at all. Same for `decisions`, `state.blocked`, `state.in_progress`, etc. Example — if an investigation session has no `what_changed` and no `state.blocked`, the final JSON should have neither key present, not `"what_changed": []` and `"blocked": []`. Empty fields are noise; absent fields are a signal that something genuinely does not apply.

Review the full session before writing — tools used, user corrections, unfinished threads, blockers. Be accurate; don't fabricate a clean narrative.

**Which optional fields to include:**

- **Coding session** (files changed): `what_changed`, `state`, `git`
- **Investigation/debugging** (no code changes): `findings` with root cause or discovery
- **Informational/learning**: `findings` for what was learned
- **Simple session**: required fields only

---

## Phase 3 — One-time setup (run before commit prep)

Phase 3 runs before the commit step so that any files it creates (`.gitignore` additions, `.claude/settings.json`) can be bundled into the session commit rather than left as stray untracked files.

**Skip this phase entirely if Phase 1 showed a clean working tree.** No session work means no commit to attach scaffolding to — defer scaffolding until the next session that has real work. A clean tree should stay clean.

**If Phase 1 showed work to commit, run through these checks and act only where something is missing:**

**Gitignore:** If the project has a `.gitignore`, ensure it contains `logs/`. If not, create `.gitignore` with `logs/` as its first line. Don't touch existing entries. If you modify or create this file, add it to the list of files you'll stage in Phase 4.

**SessionStart hook:** Check `.claude/settings.json` at the project root. If a hook referencing `logs/` already exists (`grep -q 'logs/' .claude/settings.json 2>/dev/null`), skip. Otherwise, create or merge in:

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

If `settings.json` already has content, merge carefully — append to the existing `SessionStart` array or add alongside other keys. Never remove existing entries. If you create or modify `.claude/settings.json`, also add it to the Phase 4 stage list.

The point of running this phase early: these scaffolding files are part of the session's work the first time the skill runs in a project. Bundling them into the session commit is much cleaner than leaving them untracked or needing a second "chore" commit.

---

## Phase 4 — Prepare and create the commit

### 4a. Decide if there's anything to commit

From `git status --short`:

- **Clean tree** (empty output, or only untracked files that are all under `logs/`): no commit. Jump to Phase 5 and record "no commit — working tree clean."
- **Merge in progress** (`MERGE_HEAD` existed in Phase 1): no commit. Tell the user to resolve the merge manually. Jump to Phase 5.
- **Something to commit:** continue.

### 4b. Safety scan

Scan the list of changed and untracked files against these patterns:

- `.env`, `.env.*` — except `.env.example`, `.env.sample`, `.env.template`
- `*credentials*`, `*secret*`
- `*.key`, `*.pem`
- `id_rsa*`, `id_ed25519*`, `*.ppk`
- Any file > 5 MB (flag, don't block)

If any **blocking** match is found, stop. Tell the user exactly which file(s) tripped the scan, and ask: exclude them from the commit, or abort. Do not proceed to `git add` until they answer.

For size warnings, mention them and proceed unless the user says otherwise.

Also consider the diff content itself — if you spot obvious secret shapes (AWS keys starting with `AKIA`, long hex strings in a new `.env`-like file, `BEGIN PRIVATE KEY` blocks, `-----BEGIN OPENSSH PRIVATE KEY-----`), treat the same as a blocking match. Diff-content scanning is a heuristic, not a guarantee — err on the side of stopping.

### 4c. Decide what to stage

Build an explicit list of files to stage:

1. Start with everything from `git status --short`.
2. Remove anything the safety scan excluded.
3. Remove anything under `logs/` (gitignored, but being explicit costs nothing and protects against misconfiguration).
4. **Add any scaffolding files Phase 3 created or modified** (`.gitignore`, `.claude/settings.json`). These are part of this session commit so the working tree ends clean.

**Use explicit file paths.** Never `git add -A`, `git add .`, or `git add -u`. Pass each path to `git add`.

### 4d. Draft the commit message

Read the last 5-10 commits to match repo style:

```bash
git log -10 --format="%h %s%n%b%n---"
```

Observe:

- **Subject verb form** — imperative ("Add X") vs past tense ("Added X"). Match what's there.
- **Conventional-commits prefixes** — does the repo use `feat:`, `fix:`, `docs:`, etc.? If yes, match. If no, don't invent them.
- **Body wrap width** — usually ~72 characters.
- **Co-author trailer** — exact format used in recent commits.
- **Subject case** — sentence case or lowercase?

**Structure:**

- **Subject line** — ≤ 72 chars, no trailing period. One clear sentence. Verb first.
- **Blank line.**
- **Body** (optional) — wrap at ~72. Explain the *why*, not the *what*. The diff shows what changed; the body answers "why did this need to change?" Skip the body entirely for truly trivial changes (typo fix, version bump).
- **Blank line, then co-author trailer** — matching the repo's existing style. If none exists, use `Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>`.

**Good subjects:**

- `Add checkpoint-commit skill with safety scanning`
- `Fix eval-viewer crash when benchmark.json is missing stddev`
- `Rewrite auth middleware to use JWT refresh tokens`

**Bad subjects:**

- `Updates` — says nothing.
- `Fixed bug` — which bug? what was the fix?
- `Added new feature for the user authentication system that uses JWT refresh tokens for longer sessions` — too long; keep detail for the body.

**Good body example:**

```
Add checkpoint-commit skill with safety scanning

Pairs the existing checkpoint flow with an automatic commit step
so sessions can end in a committed state in one action. Safety
rails prevent pushing, amending, bypassing hooks, or staging
files that match secret patterns.

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>
```

### 4e. Create the commit

Pass the message via heredoc to preserve formatting:

```bash
git add <path1> <path2> <path3>
git commit -m "$(cat <<'EOF'
<subject>

<body>

<co-author trailer>
EOF
)"
```

Then run `git status` and `git log -1 --format="%h %s"` to confirm the commit landed and capture the new short hash.

### 4f. Pre-commit hook failures

If `git commit` fails because a pre-commit hook rejected the change:

1. **Read the hook output.** Understand what failed — formatter, linter, tests, type check.
2. **If auto-fixable** (a formatter rewrote files): re-stage the now-fixed files and create a NEW commit with the same message.
3. **If it needs code changes**: fix the underlying issue, re-stage, make a new commit.
4. **If you can't fix it**: leave the changes staged, add a note to the checkpoint's `state.blocked` field describing the hook failure, and tell the user what's stuck. Continue to Phase 5 without a commit.

**Never pass `--no-verify`.** Hooks exist for a reason. A failing hook found a real problem.

**Never `--amend`.** Failed commit attempts do not create a commit, so there's nothing to amend. Even if a commit did succeed and you want to "fix" it, a new commit is safer: it preserves history, and it's trivial to squash later if the user wants a cleaner log.

---

## Phase 5 — Update `logs/SUMMARY.md`

Append one line to `logs/SUMMARY.md`. Create the file if it doesn't exist.

Format:

```
- **YYYY-MM-DD HH:MM** (<branch>) — <summary>. Next: <first next step, abbreviated>. [<short-hash>]
```

Include the short hash in square brackets at the end **only if** a commit was successfully created. Omit it otherwise.

Keep each entry under 150 characters. **Cap at 30 entries** — if the file exceeds 30 lines, trim the oldest entries from the top.

---

## Phase 6 — Confirm

Print, in this order:

1. `Checkpoint saved: logs/<filename>`
2. The one-line checkpoint summary
3. `Next: <first next_steps item>`
4. Commit line — one of:
   - `Committed: <short-hash> <subject>`  *(commit succeeded)*
   - `No commit: working tree clean`  *(nothing to commit)*
   - `No commit: merge in progress — resolve and commit manually`
   - `No commit: not a git repo`
   - `No commit: <specific blocker>`  *(e.g., hook failure, secret detected, user aborted)*
5. If a commit was made: `Not pushed. Run 'git push' when ready.`

Keep the confirmation short — five or six lines. No extra prose.

---

## Why the safety rails matter

Each rule exists because of a specific way people get burned:

- **No push** — the commit might need review, rebase, or squash before it becomes public. Pushing auto-denies that option.
- **No amend** — rewrites history. If the previous commit was referenced or pushed, amend is destructive; if not, a new commit is just as cheap.
- **No `--no-verify`** — skipping hooks ships broken code. If a hook fails, the hook found a real problem; the fix is the fix, not the bypass.
- **Secret scan** — a committed secret cannot be fully un-committed. Even after rewriting history, it lives in the reflog, and if pushed, it's in every clone. Prevention is the only cure.
- **Explicit file paths** — `git add -A` has committed more unintended files than any other git command. Always know exactly what you're staging.

When in doubt on any of these, stop and ask the user rather than pushing through.
