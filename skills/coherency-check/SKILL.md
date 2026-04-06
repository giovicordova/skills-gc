---
name: coherency-check
description: "Cross-document and cross-code coherency analysis. Reads a set of documents, code files, configs, or design tokens and finds contradictions, conflicting values, overlapping definitions, and inconsistencies across them — then helps resolve each conflict interactively. Use when the user says 'coherency check', 'check these docs are consistent', 'do these files contradict each other', 'make sure everything aligns', 'find inconsistencies', 'check for contradictions', or any request to verify that multiple files tell the same story. Also use when the user has assembled specs, plans, configs, CSS/design tokens, or documentation and wants to catch places where they point in different directions. Works for markdown docs, code files, config files, stylesheets, and any mix of these."
argument-hint: "[path, glob, or file list — e.g. 'docs/' or '*.md' or 'SPEC.md PLAN.md README.md']"
---

# Coherency Check

Read a set of documents, code files, configs, or design tokens and surface every place where they contradict, overlap, or diverge from each other. The goal is to catch inconsistencies before they cause confusion downstream — whether that's in a spec handoff, a documentation set, a configuration stack, a design system, or planning documents.

## Why this matters

When multiple files describe the same system, drift is inevitable. File A says the timeout is 30 seconds, file B says 60. The PRD says "users can delete their account", the API spec has no delete endpoint. One config sets `DEBUG=true`, another sets `LOG_LEVEL=error`. A CSS variables file defines `--primary: #2563eb` but the Tailwind config uses `primary: '#3b82f6'`. These inconsistencies are invisible when you read files one at a time — they only surface when you cross-reference.

## Step 1: Gather the files

**If `$ARGUMENTS` is provided:** interpret it as a path, glob pattern, or space-separated file list.
- A directory path (e.g. `docs/`) → read all readable files in it (non-binary, skip node_modules, .git, etc.)
- A glob (e.g. `*.md` or `**/*.yaml`) → expand and read all matches
- Explicit file list (e.g. `SPEC.md PLAN.md README.md`) → read those files

**If `$ARGUMENTS` is empty:** ask the user which files or directory to check. Don't guess.

Use Glob to find files, then Read each one. Track what you read — you'll reference these files by name throughout the report.

**Scope guard:** if the file set exceeds 30 files, warn the user and ask whether to narrow the scope. Large file sets dilute the analysis — coherency checking works best on 2–15 documents that are supposed to describe the same system or topic.

## Step 2: Extract claims

Read each file carefully and extract its **claims** — concrete, verifiable statements about how things work, what values should be, what exists, what's planned, or what's required. Focus on:

- **Facts and values** — numbers, names, URLs, versions, settings, thresholds, dates, deadlines
- **Limits and quotas** — rate limits, size caps, tier-specific restrictions (free vs paid), maximums, minimums. These are high-value targets for inconsistency because they're often stated in multiple places (docs, configs, error messages) and drift independently.
- **Definitions** — what terms mean, what components do, what roles are responsible for what
- **Requirements** — what must happen, what's allowed, what's forbidden
- **Architecture** — how components connect, what depends on what, data flow, responsibility boundaries
- **Status and state** — what's done, what's planned, what's deprecated, what's active
- **Design values** — colours, spacing, font sizes, breakpoints, animation durations, z-indexes, or any token/variable that appears in multiple files (CSS variables, Tailwind config, design tokens JSON, component styles)

Don't extract opinions or aspirational language unless it contradicts a concrete claim elsewhere.

For each claim, note:
- The file and approximate location (section header or line range)
- The claim itself, paraphrased concisely
- The exact quote or value if precision matters (e.g. a specific number or config value)

You don't need to list these claims to the user — they're your working material for the next step.

## Step 3: Cross-reference

Compare every claim against every other claim across files. Look for:

### Contradictions
Two files make incompatible statements about the same thing. This is the most critical finding.

**Examples:**
- File A: "Session timeout is 30 minutes" / File B: "Sessions expire after 1 hour"
- PRD: "Users can delete their account" / API spec: no delete endpoint defined
- Config A: `MAX_RETRIES=3` / Config B: `MAX_RETRIES=5`

### Overlapping definitions
Multiple files define or describe the same concept, but differently. Not necessarily contradictory, but a maintenance risk — when the concept evolves, some definitions will get updated and others won't.

**Examples:**
- Three different files each explain what the "onboarding flow" consists of, with slightly different step lists
- README and CONTRIBUTING.md both describe the deployment process with different instructions

### Terminology drift
The same thing called by different names across files, or the same name used for different things.

**Examples:**
- "workspace" in one file means a user's project, in another it means a directory on disk
- One file calls it "organisation", another "team", another "account" — all meaning the same entity

### Stale references
A file references something (a file, endpoint, config key, feature) that doesn't exist in the other files, or that another file marks as deprecated/removed.

### Temporal context

If any file is a changelog, version history, or migration log, use it as a timeline to determine which contradicting values are current and which are stale. A changelog that says "changed X from A to B in v2.3" tells you that any file still showing A was not updated after v2.3. Flag this explicitly — note the version that changed it and which files are behind. This turns an ambiguous "A vs B" contradiction into a clear "B is current, file X is stale since v2.3."

## Step 4: Write the report

Print the report directly in the conversation. Structure it as follows:

### If no issues found

Keep it short:
```
## Coherency Check: [scope summary]
**[N] files checked. No contradictions or inconsistencies found.**
Files: [list]
```

### If issues found

```
## Coherency Check: [scope summary]

**[N] files checked — [X] contradictions, [Y] overlaps, [Z] other issues found.**

### Contradictions

| # | Issue | File A | File B | Severity |
|---|-------|--------|--------|----------|
| 1 | [what conflicts] | [file:location] says "[quote]" | [file:location] says "[quote]" | high/medium/low |

### Overlapping Definitions
[For each: what's defined multiple times, where, and how the definitions differ]

### Terminology Drift
[For each: the concept, the different names used, where]

### Stale References
[For each: what's referenced, where, and why it appears stale]
```

**Severity guide for contradictions:**
- **High** — will cause bugs, broken behaviour, or wrong decisions if not resolved. Values that code or people will actually use.
- **Medium** — causes confusion or inconsistent understanding. Definitions, descriptions, process docs.
- **Low** — cosmetic or unlikely to cause real problems. Formatting, phrasing, non-critical metadata.

**Reporting rules:**
- Be specific. Exact file names, section headers, line numbers, quoted values. Not "these files disagree about timeouts".
- Group related issues. If three files all disagree about the same setting, that's one contradiction with three sources, not three separate contradictions.
- Lead with contradictions — they're the ones that cause real damage. Overlaps and terminology drift are maintenance concerns, not emergencies.

## Step 5: Resolve

After presenting the report, if there are contradictions:

> "There are [X] contradictions to resolve. I'll walk through each one — tell me which version should be the source of truth, or if you'd like a different value entirely."

Then for each contradiction, present it clearly:

> **Contradiction #1: [topic]**
> - **Option A** ([file]): [what it says]
> - **Option B** ([file]): [what it says]
>
> Which should we go with — A, B, or something else?

If the answer is obvious from context (e.g. one file is clearly more authoritative, like a config file vs. a README approximation), say so:

> The config file is likely authoritative here since it's what the code actually reads. Want me to update the README to match?

Wait for the user's response before moving to the next contradiction. Don't batch all questions at once — resolve sequentially so earlier decisions can inform later ones.

For overlaps and terminology drift, don't ask one-by-one. Instead, summarise recommendations:

> "For the overlapping definitions, I'd recommend [X] as the single source of truth — the other files should reference it rather than redefine it. Want me to consolidate?"

## Step 6: Fix

After resolution, offer to implement the fixes:

> "Want me to update the files to resolve these?"

**If yes:**
1. Apply fixes one file at a time
2. For contradictions: update the non-authoritative file to match the authoritative one
3. For overlaps: consolidate to a single definition and replace duplicates with references
4. For terminology: standardise on the agreed term across all files
5. After all fixes, do a quick re-scan to confirm no new inconsistencies were introduced

**If no:** end. The report stands on its own.
