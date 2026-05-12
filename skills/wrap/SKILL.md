---
description: Save progress to the project's auto-memory, commit, and push. Trigger on /wrap, "wrap up", "save progress", "checkpoint".
allowed-tools: Bash(git add *) Bash(git commit *) Bash(git push *) Bash(git status*) Bash(git diff*) Bash(git log*) Bash(git branch*)
---

# Wrap

Memory first, git second. The sweep is where wraps usually under-save.

## 1. Memory sweep
Read `MEMORY.md`. For each type, ask "anything from this session?" — write a file + a MEMORY.md line per yes.
- **user** — new role, skill, preference signals.
- **feedback** — corrections AND validated approaches (second half is easy to miss); workflow signals count. Format: rule, **Why:**, **How to apply:**.
- **project** — non-code-derivable decisions, trade-offs, rejected alternatives. Skip ephemeral status.
- **reference** — pointers outside the diff (dashboards, docs, systems).

Skip anything derivable from code, git log, or the commit message. Update existing files instead of duplicating; remove memories this session contradicts.

## 2. Commit + push
`git status` → stage → commit (message explains *why*) → push.

## 3. Session log
Append one line to `memory/sessions.log`: `YYYY-MM-DD HH:MM — <one-sentence digest of what this session did> — <short-hash>`. Create the file if missing and add a pointer to `MEMORY.md` (`- [Session log](sessions.log) — chronological one-liners of past sessions`). One line per wrap, ever. No multi-line entries.

## 4. Report
2–3 lines: count of memories + topics, commit ref, and session log line added. No session recap.
