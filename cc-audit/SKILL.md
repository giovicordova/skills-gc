---
name: cc-audit
description: "Audit a project's Claude Code setup against official Anthropic documentation. Evaluates CLAUDE.md, skills, sub-agents, hooks, MCP, permissions, settings, feature selection, and rules — then produces AUDIT-REPORT.md with sourced findings. Use this skill when the user asks to audit, review, or check their Claude Code setup, wants to know if they're using Claude Code features correctly, asks 'am I set up right', 'audit my claude config', 'check my CLAUDE.md', or any request to evaluate how well a project is configured for Claude Code."
disable-model-invocation: true
context: fork
allowed-tools:
  - Read
  - Glob
  - Grep
  - Write
  - Bash(npx @playwright/cli *)
  - AskUserQuestion
  - mcp__anthropic-docs__search_anthropic_docs
  - mcp__anthropic-docs__get_doc_page
  - mcp__anthropic-docs__list_doc_sections
  - mcp__anthropic-docs__index_status
  - mcp__plugin_context7_context7__resolve-library-id
  - mcp__plugin_context7_context7__query-docs
---

# CC Audit

Audit a project's Claude Code setup against official Anthropic documentation. Produces `AUDIT-REPORT.md` in the project root.

## Overview

This skill evaluates 9 areas of a Claude Code project setup:

| Area | What it checks |
|------|---------------|
| CLAUDE.md | Structure, length, content quality, proper use |
| Skills | Frontmatter, descriptions, invocation control, right tool for the job |
| Sub-agents | Tool restrictions, model selection, when to use vs skills |
| Hooks | Event handling, matchers, deterministic automation |
| MCP | Server configurations, scope, usage |
| Permissions | Allowlists, deny rules, sandboxing |
| Settings | Scope, configuration |
| Feature Selection | Right feature for the right job, missing opportunities |
| Rules | Path scoping, organisation, overlap with CLAUDE.md |

Every finding is tagged **good** (keep this), **improve** (works but could be better), or **fix** (against best practices) and must cite a documentation source fetched during this session.

## Phase 1: Verify documentation sources

Check which documentation sources are available, in this order:

1. **Try MCP first** — call `mcp__anthropic-docs__index_status`
   - Succeeds → use "MCP-primary mode" (MCP default, Playwright fallback)

2. **If MCP failed, try Playwright CLI**
   - Run: `npx @playwright/cli open https://docs.anthropic.com/en/docs/claude-code/overview`
   - Run: `npx @playwright/cli snapshot` to confirm it loads
   - Loads → use "Playwright-only mode"
   - Close: `npx @playwright/cli close`

3. **Both failed → STOP**
   - Use AskUserQuestion to tell the user:

```
CC Audit requires at least one documentation source. Set up either:

Option A — Anthropic Documentation MCP (recommended):
  claude mcp add anthropic-docs -- npx -y @anthropic-ai/anthropic-docs-mcp

Option B — Playwright CLI:
  npm install -g @playwright/cli

Then restart Claude Code.
```

## Phase 2: Understand the project

### Find descriptive files

Glob for these in the project root:
- `README*`, `VISION*`, `CLAUDE.md`, `.claude/CLAUDE.md`
- `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`
- `docs/**/*.md` (first 5 results only)

### Read what you found

Read each discovered file. For package manifests, extract: name, description, key dependencies. Build a list of major libraries/services the project relies on.

### Map the Claude Code setup

Glob for:
- Everything under `.claude/` (including `.claude/rules/**/*.md`)
- Root-level `CLAUDE.md` or `CLAUDE.local.md`

### Form understanding

Document in this exact format:

```
PROJECT: [what the project is, 1-2 sentences]
GOAL: [what it's trying to achieve, 1-2 sentences]
KEY DEPENDENCIES: [major libraries/services from package manifests — skip if none found]
CLAUDE CODE FEATURES IN USE: [list]
```

**Your next tool call MUST be AskUserQuestion.** Do not call Read, Glob, Grep, or any other tool before confirming with the user.

## Phase 3: Confirm with user

Call AskUserQuestion with:

```
CC Audit — Project Understanding

From my analysis, this project is [your understanding].
The goal is [your understanding of the goal].

Key dependencies identified: [list, or "none found"]

Claude Code features currently in use: [list what you found]

Is this accurate, or do you have additional documentation I should review?
```

Wait for the user's response. If they correct you or point to more files, read those and update your understanding.

After the user confirms, write:

```
CONFIRMED GOAL: [the user-confirmed goal, in their words or yours if they said "yes"]
```

Do not proceed to Phase 4 until CONFIRMED GOAL is written.

## Phase 4: Audit

### Step 4.0: Bulk doc fetch

Fetch all documentation upfront. Use the documentation fetching protocol described below for each path:

- `/docs/en/memory`
- `/docs/en/best-practices`
- `/docs/en/skills`
- `/docs/en/sub-agents`
- `/docs/en/hooks-guide`
- `/docs/en/permissions`
- `/docs/en/settings`
- `/docs/en/mcp`
- `/docs/en/features-overview`

**Documentation fetching protocol:**

In MCP-primary mode:
1. Call `mcp__anthropic-docs__get_doc_page` with the path
2. Content returned → use it, record URL
3. Empty/error → fall back to Playwright

Playwright fetch (fallback or primary):
1. `npx @playwright/cli open https://docs.anthropic.com/en/docs/claude-code/[topic]`
2. `npx @playwright/cli snapshot` to capture content
3. Extract relevant guidance
4. `npx @playwright/cli close`
5. Record the full URL

Rules:
- Both fail for a path → skip that reference
- All references for an audit area fail → skip the area, note "Skipped — documentation unavailable"
- Never fabricate a URL — only use URLs you actually fetched
- Append `(via MCP)` or `(via Playwright CLI)` to source lines

### Step 4.1: Instructions specialist

Read `agents/instructions-specialist.md` and follow its instructions to audit CLAUDE.md and Rules as a coherent instructions system.

### Step 4.2: Components specialist

Read `agents/components-specialist.md` and `references/skills-guide.md`, then audit Skills and Sub-agents as a coherent components system.

### Step 4.3: Automation specialist

Read `agents/automation-specialist.md` and audit Hooks, Permissions, and Settings as interconnected execution control.

### Step 4.4: Integration specialist

Read `agents/integration-specialist.md` and audit MCP and Feature Selection for coherence with the project's goal.

### Step 4.5: Adversarial review

Read `agents/adversarial-reviewer.md`. Filter all findings from Steps 4.1–4.4 against the CONFIRMED GOAL. Remove weak, unsourced, duplicate, or irrelevant findings. The output of this step is the final filtered findings set.

## Phase 5: Write report

Write `AUDIT-REPORT.md` in the project root using this structure:

```markdown
# Claude Code Audit Report

> Generated on [today's date]

## Project Understanding

[Confirmed project goal from Phase 3]

## Current State

| Area | What it is | Status |
|------|-----------|--------|
| CLAUDE.md | Your project's instructions to Claude | [Exists / Missing] |
| Skills | Reusable slash-command workflows | [X found / None] |
| Sub-agents | Isolated Claude sessions for specific tasks | [X found / None] |
| Hooks | Automated actions that run before/after Claude acts | [Configured / Not configured] |
| MCP | Connections to external tools and services | [X servers / Not configured] |
| Permissions | What Claude is allowed to do without asking | [Configured / Default] |
| Settings | Project-level Claude Code configuration | [Configured / Default] |
| Rules | Targeted instructions scoped to specific files or folders | [X found / None] |

## Findings

[For each area with findings:]

### [Area Name] — [plain description from table above]

#### [good/improve/fix] Finding title

- **Current**: What exists now
- **Recommendation**: What should change (omit for "good" findings)
- **Project relevance**: Why this matters for this specific project
- **Source**: [Doc section title](full URL) (via MCP|Playwright CLI)

## Priority Actions

| # | Priority | What to do | Why it matters for your project |
|---|----------|-----------|-------------------------------|
| 1 | fix | [one-sentence action] | [one-sentence reason] |
| 2 | improve | [one-sentence action] | [one-sentence reason] |

## Next Steps

To implement these recommendations:

1. Start a new Claude Code session
2. Enter Plan mode (Shift+Tab)
3. Share this report: "Read AUDIT-REPORT.md and create an implementation plan for the recommendations"
4. Review the plan, then switch to Normal mode to execute
```

**Writing rule:** Write all findings in plain language. The reader may not be a developer — if a technical term is necessary, explain it briefly in parentheses.

After writing the report, print a summary to the conversation:

```
Audit complete. Report written to AUDIT-REPORT.md.

Found [X] findings: [Y] good, [Z] to improve, [W] to fix.

Top priorities:
1. ...
2. ...
3. ...

Open AUDIT-REPORT.md for the full report.
```
