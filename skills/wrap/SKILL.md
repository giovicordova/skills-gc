---
description: Wrap up the session — save durable progress to the project's auto-memory, commit, push. Trigger on /wrap, "wrap up", "save progress", "checkpoint".
allowed-tools: Bash(git add *) Bash(git commit *) Bash(git push *) Bash(git status*) Bash(git diff*) Bash(git log*) Bash(git branch*)
---

End-of-session handoff. Three steps:

1. Save durable signal to project auto-memory (path is in your system prompt under `# auto memory`). Update existing files where they fit; add `MEMORY.md` pointers. Skip ephemeral chatter and anything already in CLAUDE.md.
2. Stage explicit paths only (never `git add -A`). Commit with a one-sentence subject and a session-narrative body via HEREDOC. Include the Claude co-author trailer.
3. Push to upstream (`-u origin <branch>` if none set). Never force-push.

Output: two lines — what was saved, commit subject + push result.
