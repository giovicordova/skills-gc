---
name: auto-improve
description: Run a configurable loop that incrementally improves a target (agent, skill, doc, folder, CLAUDE.md, README) by verifying every external claim (URLs, library names, quoted attributions, named principles, project-style rules) against authoritative sources and tightening prose one small pass at a time. Use whenever the user says "auto-improve X", "polish X over time", "loop improving X", "verify and tighten X", "keep refining X", "iterate on X for a while", or invokes /auto-improve. Each pass touches one file, either editing in place (staged for review) or appending compact checkbox findings to AUTO-IMPROVE-FINDINGS.md for later interactive review. Mode, loop interval, and target are chosen interactively at start. NOT for first-draft writing, code refactors, or bug fixes.
allowed-tools: Read, Edit, Write, Bash, Glob, Grep, WebFetch, Skill, AskUserQuestion
---

# Auto-improve

Incrementally improve a target through a configurable loop. Each pass touches **one file**, makes a small verified change, and either stages it or records it as a checkbox finding. Many small verified improvements beat one big rewrite.

## First thing every invocation: state check

Read `.auto-improve.state` at repo root.

- **Missing** → this is the start. Run "Setup" below, then run one pass.
- **Exists** → you're inside a loop iteration. Skip setup. Read config from state and run one pass.

## Setup (first run only)

Ask the user in one `AskUserQuestion` call — **only the questions you don't already have answers to** from the invocation arguments or context:

1. **Target** — if the user passed one as argument, skip this. Otherwise list 3-5 candidates picked from the repo: recently-edited files, files with TODOs, longest markdown docs. They pick.
2. **Mode**
   - *Live-edit (stage only)* — apply edits and `git add` each pass. User commits at loop end.
   - *Findings doc* — no edits to source. Each pass appends a section to `AUTO-IMPROVE-FINDINGS.md` for later review.
3. **Loop interval** — every 5 / 10 / 15 / 30 min, self-paced (Claude picks each gap), or one pass only (smoke test).

Write answers to `.auto-improve.state` as JSON:
```json
{"target": "...", "mode": "live-edit|findings", "interval": "10m|self-paced|once", "started_at": "...", "iteration_count": 0}
```

Then schedule the loop:
- **Fixed interval** (5/10/15/30m) — load `CronCreate` via `ToolSearch` and schedule the prompt `/auto-improve` to re-fire on that cadence. State carries everything.
- **Self-paced** — at the end of each pass, load `ScheduleWakeup` and schedule the next wake with a delay you choose based on what you observed.
- **Once** — skip scheduling. Run the pass and stop. Useful for smoke tests and one-off polish.

Add `.auto-improve.state`, `.auto-improve.log`, and `AUTO-IMPROVE-FINDINGS.md` to `.gitignore` if not already there.

## The pass

One file per pass. Steps in order.

### 1. Scope

If target is a folder, pick **one** file this pass. Priority: not touched in the last 3 iterations (check `.auto-improve.log`), then by longest line count, oldest mtime, presence of TODOs, or repetitive prose.

Announce in one sentence which file and why.

### 2. Read & inventory

Read the file. Note:
- Line count
- External claims: URLs, library/API names, version numbers, command syntax, file paths the doc references
- 1-2 specific weaknesses: verbose phrasing, repetition, mismatched description-vs-behavior, unclear trigger contracts (for skills), stale references

### 3. Verify external claims

For each external claim:
- URLs → `WebFetch` and confirm content matches
- Library / API / version → use a context7 MCP if available, else `WebFetch` official docs
- Commands → `command -v <cmd>` and check `--help` output for stated flags
- File paths → verify they exist
- **Quoted attributions** ("X said Y", "as Knuth wrote") → search authoritative sources. Many famous quotes are misattributed (e.g. "two ears, one mouth" is Zeno, not Epictetus). Don't skip these.
- **Named principles or definitions** (Occam's Razor, YAGNI, Chesterton's Fence, etc.) → verify the explanation matches the principle's actual content, not the popular paraphrase. Folk versions are common and wrong.
- **Project-style rules** → read `~/.claude/CLAUDE.md` and every `CLAUDE.md` from repo root down to the target. Flag every violation (no em-dashes, no emojis, plain-language rules). One finding per violation type, with line numbers.

If a claim is wrong and the fix is obvious: prepare the fix.
If uncertain and the fix would be speculative: annotate with `<!-- TODO(auto-improve): verify <claim> -->` and move on. Don't guess.

### 4. Tighten prose

Run these checks in order. Each is a potential finding. Don't default to "stable, exit" until all return nothing.

- Style-rule violations from Step 3 — every instance, with line numbers.
- Spelling consistency (US vs UK drift across the same file).
- Description-vs-body redundancy: does the frontmatter `description:` repeat content that's already in the body?
- Restatements between adjacent sections.
- Filler adjectives ("simply", "just", "custom", "powerful", "comprehensive").
- For SKILL.md targets, check frontmatter completeness:
  - `description:` has trigger phrases + negative scope ("NOT for X") + output shape
  - `allowed-tools:` present if the skill body uses tools that would prompt otherwise
  - `argument-hint:` matches the placeholders the body actually references

If 3+ of the above turn up nothing AND the file is markdown with existing signal, dispatch `hermetic-distiller` for a deeper compression pass. Otherwise apply findings inline.

For YAML frontmatter `description:` fields, do NOT shorten aggressively — these are load-bearing trigger contracts. Preserve trigger phrases and "NOT for X" clauses.

Apply project style: no em-dashes, plain terms, fewer lines.

### 5. Coherency

If the file has known neighbors, check the edge:
- `skills/<X>/SKILL.md` ↔ README skills table row
- `agents/<X>.md` ↔ memory files it references
- `CLAUDE.md` ↔ skill contracts it describes
- frontmatter `description:` ↔ body behavior

For 2+ files, dispatch `coherency-check` via Skill. For one edge, inline read suffices.

### 6. Memory-touch gate

Project auto-memory lives at `~/.claude/projects/<url-encoded-project-path>/memory/`. If the proposed change requires editing any file there, under `~/.claude/memory/`, or `~/.claude/CLAUDE.md`, **pause** and call `AskUserQuestion`:
- Show the absolute path and the proposed diff (≤10 lines).
- Options: `yes`, `skip this file`, `skip all memory edits for this session` (sets a flag in `.auto-improve.state`).

Never edit memory silently.

### 7. Apply or record

**Live-edit mode**: write the edit (`Edit` or `Write`), then `git add <file>`. Do NOT commit.

**Findings mode**: append to `AUTO-IMPROVE-FINDINGS.md`. Format exactly:
```
## Iter <N> — <YYYY-MM-DD HH:MM> — <relative/path>

- [ ] L<line>: <one-line summary>. Proposed: <change>
- [ ] Verify: <claim> → <result>, source: <url, or local path:line>
- [ ] Trim: <before> → <after> lines, no signal loss
```
One section per iteration. Compact lines. No prose paragraphs.

### 8. Log

Append one line to `.auto-improve.log`:
```
<ISO timestamp> | <target> | <file touched> | <mode> | <lines Δ> | <claims verified> | <claims fixed>
```

Increment `iteration_count` in `.auto-improve.state`.

Print a one-sentence summary to the user.

If 5+ consecutive passes on the same target produced no findings, also print: `<target> appears stable. Press Esc to stop the loop.`

### 9. Schedule next (self-paced only)

If `interval = "self-paced"`, schedule next wake now via `ScheduleWakeup`. Fixed-interval mode is already covered by the cron job from setup.

## After the loop ends (`/auto-improve --review`)

When the user invokes review (or just asks to go through the findings):

- **Findings mode**: read `AUTO-IMPROVE-FINDINGS.md`. Dispatch `interactive-qa` with the unchecked items grouped by file. For each, ask apply / dismiss / edit-then-apply. Apply approved items. Delete the doc and `.auto-improve.state` when done.
- **Live-edit mode**: show `git diff --staged --stat` and a compact diff. Offer one commit, or unstage everything, or pick files. Then delete `.auto-improve.state`.

## When to refuse the pass

- Target path doesn't exist or escapes the repo
- Target is binary, generated, or vendored
- Improvement requires code refactoring or bug fixing → say so and point at `/gsd` or `feature-dev` instead

## Per-pass exit conditions

- Nothing needs work this pass → log "stable" and exit early so the loop budget moves elsewhere next time.
- Verification fails and fix is non-trivial → leave a TODO annotation, exit pass.
- Edit would break a neighbor's coherency → don't write; record as a finding instead, exit pass.

## State files

| File | Purpose | Lifetime |
| --- | --- | --- |
| `.auto-improve.state` | Runtime config (target, mode, interval, counters) | Deleted at loop end after review |
| `.auto-improve.log` | Append-only history of all passes | Persists |
| `AUTO-IMPROVE-FINDINGS.md` | Findings-mode output | Deleted after `/interactive-qa` review |

## Why this shape

- **One file per pass** keeps every change reviewable and revertable.
- **Verification first** — most "auto-improve" tools just rewrite. This one checks claims against the real world.
- **Two modes** — live-edit when you trust the skill, findings when you want a human review gate.
- **State file + log** turn N disconnected runs into N cumulative improvements.
- **Memory-touch gate** keeps the skill from silently mutating files that hold cross-session truth.
