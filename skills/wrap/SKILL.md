---
description: Save progress to the project's auto-memory, commit, and push. Trigger on /wrap, "wrap up", "save progress", "checkpoint".
allowed-tools: Bash(git add *) Bash(git commit *) Bash(git push *) Bash(git status*) Bash(git diff*) Bash(git log*) Bash(git branch*)
---

# Wrap

Memory first, git second. The sweep is where wraps usually under-save.

## 1. Memory sweep
Read `MEMORY.md`. Scan the session against four prompts; write a file + MEMORY.md line per hit:
- **user** — new role, skill, or preference signal.
- **feedback** — a correction OR a validated approach (the second is easy to miss).
- **project** — a decision, trade-off, or rejected alternative not derivable from code.
- **reference** — a pointer outside the diff (dashboard, doc, system).

Rules: skip anything in code, git log, or the commit message. Update an existing file rather than duplicate; delete any memory this session contradicts.

## 2. Commit + push
`git status` → stage → commit (message explains *why*) → push.

## 3. Session log
Append one line to `memory/sessions.log`: `YYYY-MM-DD HH:MM — <one-sentence digest of what this session did> — <short-hash>`. Create the file if missing and add a pointer to `MEMORY.md` (`- [Session log](sessions.log) — chronological one-liners of past sessions`). One line per wrap, ever. No multi-line entries.

## 4. Report
2–3 lines: count of memories + topics, commit ref, and session log line added. No session recap.
