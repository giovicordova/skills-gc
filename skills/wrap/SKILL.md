---
description: Save the current session's progress to project auto-memory, then commit and push. Use when the user types /wrap or asks to wrap up the session, save progress, or checkpoint.
disable-model-invocation: true
allowed-tools: Bash(git add *) Bash(git commit *) Bash(git push *) Bash(git status*) Bash(git diff*) Bash(git log*) Bash(git branch*)
---

# /wrap

End-of-session handoff. Three steps, in order.

## 1. Save progress to project auto-memory

Project auto-memory lives under `~/.claude/projects/<sanitised-cwd>/memory/`. The exact path for the current project is in your system prompt under the **auto memory** section — use that, don't guess. If that section is missing, derive the path from the current working directory (replace `/` with `-`, prefix with `-`).

Decide what's worth keeping based on the **auto memory** rules in your system prompt — durable signal only (project state, decisions, feedback, references). Skip ephemeral task chatter, code patterns derivable from the repo, and anything already in CLAUDE.md.

For each item worth saving:
- Update an existing memory file if one fits (read it first).
- Otherwise create a new file with the standard frontmatter (`name`, `description`, `type`).
- Add or update the one-line pointer in `MEMORY.md`.

If nothing from the session is worth persisting, say so and skip to step 2.

## 2. Commit

Stage only what's changed in this session (working tree + the memory updates from step 1). Do **not** use `git add -A` or `git add .` — list paths explicitly to avoid sweeping in stray files or secrets.

Commit message format:
- Subject: one short sentence summarising the session (what changed and why).
- Body: a tight paragraph of the session narrative — what we worked on, key decisions, what's next. Future-you should be able to pick up cold from this.

Use a HEREDOC for the message so newlines render correctly. Co-author trailer as usual.

## 3. Push

`git push` to the current branch's upstream. If no upstream is set, push with `-u` to `origin <current-branch>`. Never force-push.

## Output

After all three steps, give the user a two-line summary:
- What got saved to memory (file names, or "nothing worth saving").
- The commit subject + push result (branch name + remote).

Nothing else. No recap of what happened mid-session — that's what the commit body is for.
