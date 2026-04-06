---
name: cc-audit
description: "Audit a project's Claude Code setup against official Anthropic documentation. Evaluates 9 areas: CLAUDE.md, Rules, Skills, Sub-agents, Hooks, Permissions, Settings, MCP servers, and Feature Selection. Produces a scored AUDIT-REPORT.md with findings that cite documentation sources fetched during the session. Use this skill when the user says 'audit', 'audit my setup', 'review my Claude Code config', 'check my configuration', 'how well am I using Claude Code', 'audit my CLAUDE.md', or wants to assess whether their project is making effective use of Claude Code features. Even if the user only mentions one area (e.g., 'are my hooks right?'), use this skill — it evaluates all 9 areas for a complete picture."
---

# CC Audit

Comprehensive audit of a project's Claude Code configuration against current Anthropic documentation. Evaluate 9 areas and produce a scored report — plain language, every finding backed by a documentation source fetched in this session.

The 9 audit areas group into four specialist domains:

| Domain | Areas |
|--------|-------|
| Instructions | CLAUDE.md, Rules |
| Components | Skills, Sub-agents |
| Automation | Hooks, Permissions, Settings |
| Integration | MCP servers, Feature Selection |

---

## Phase 1: Verify Documentation Sources

Documentation access is required — every finding must cite a real source. Check MCP first, then fall back to Playwright.

**Step 1 — Try MCP:**

```
mcp__anthropic-docs__search_anthropic_docs({ query: "Claude Code overview" })
```

If it responds with results, set `DOC_MODE = "MCP"`.

**Step 2 — If MCP failed, try Playwright:**

```bash
npx playwright --version 2>/dev/null
```

If available, set `DOC_MODE = "Playwright CLI"`. To fetch a doc page in this mode:

```bash
node -e "
import('playwright').then(async ({chromium}) => {
  const b = await chromium.launch({headless:true});
  const p = await (await b.newContext()).newPage();
  await p.goto('$URL', {waitUntil:'networkidle'});
  const el = await p.\$('main') || await p.\$('article') || await p.\$('body');
  console.log(await el.textContent());
  await b.close();
})
"
```

Replace `$URL` with the full Anthropic docs URL (e.g., `https://docs.anthropic.com/en/docs/agents/claude-code/memory`).

**Step 3 — If neither available, STOP.** Tell the user:

> I need access to Anthropic's documentation to run the audit. Set up one of these:
>
> **Option A — Anthropic Docs MCP (recommended):**
> `claude mcp add anthropic-docs -- npx -y @anthropic-ai/anthropic-docs-mcp`
>
> **Option B — Playwright:**
> `npm install playwright && npx playwright install chromium`

---

## Phase 2: Understand the Project

Build a mental model of the project and its Claude Code setup.

**Project identity:**
1. Read `README.md`, `CLAUDE.md`, `VISION.md`, `PROJECT.md` — whichever exist
2. Read the package manifest (`package.json`, `requirements.txt`, `pyproject.toml`, `Cargo.toml`, `go.mod`)
3. Skim the top-level directory structure

**Claude Code setup:**
4. Map `.claude/` directory contents (settings, commands, rules, MCP config)
5. Check for skills: Glob for `**/SKILL.md`
6. Check for sub-agents: Glob for `**/agents/*.md`
7. Read `.claude/settings.json` and `.mcp.json` if they exist
8. Check for rules: list `.claude/rules/` contents

Synthesise into:

```
PROJECT: <what this project is>
GOAL: <what it's trying to accomplish>
KEY DEPENDENCIES: <frameworks, libraries, services>
CLAUDE CODE FEATURES IN USE: <which of the 9 areas are configured>
CLAUDE CODE FEATURES NOT IN USE: <which areas have no configuration>
```

---

## Phase 3: Confirm with User

**This step is mandatory. Do not skip it.**

Use `AskUserQuestion` to present:
- Your project summary
- Which Claude Code features you detected and which are absent
- Any assumptions you're making

Wait for the user's response. Adjust your understanding if they correct anything. Record:

```
CONFIRMED GOAL: <user-confirmed project description and audit focus>
```

Proceed only after confirmation.

---

## Phase 4: Audit

### Step 4.0 — Bulk Documentation Fetch

Fetch all documentation upfront. This avoids repeated lookups during specialist analysis.

| # | Area | Path |
|---|------|------|
| 1 | CLAUDE.md & Memory | `/docs/en/memory` |
| 2 | Skills | `/docs/en/skills` |
| 3 | Sub-agents | `/docs/en/sub-agents` |
| 4 | Hooks (reference) | `/docs/en/hooks` |
| 5 | Hooks (guide) | `/docs/en/hooks-guide` |
| 6 | MCP | `/docs/en/mcp` |
| 7 | Permissions | `/docs/en/permissions` |
| 8 | Settings | `/docs/en/settings` |
| 9 | Feature overview | `/docs/en/features-overview` |

**MCP mode:** `mcp__anthropic-docs__get_doc_page({ path: "<path>", section: "all" })` for each.

**Playwright mode:** fetch from `https://docs.anthropic.com<path>` using the script from Phase 1.

If a page fails, note it and continue. The specialist for that area works with what's available.

### Steps 4.1–4.4 — Specialist Audits

Run each specialist in sequence. For each one, read the instruction file from this skill's `agents/` directory and follow its evaluation criteria against the fetched documentation and project state.

| Step | File to read | Areas covered |
|------|-------------|---------------|
| 4.1 | `agents/instructions-specialist.md` | CLAUDE.md + Rules |
| 4.2 | `agents/components-specialist.md` | Skills + Sub-agents |
| 4.3 | `agents/automation-specialist.md` | Hooks + Permissions + Settings |
| 4.4 | `agents/integration-specialist.md` | MCP + Feature Selection |

Each specialist produces findings in the standard format (below). **Every area must have at least one finding** — if an area is well-configured, produce a brief `[good]` finding acknowledging what the project does right. An area with zero findings is invisible in the report and leaves the reader wondering whether you forgot to check it.

Collect all findings before moving to step 4.5.

### Step 4.5 — Adversarial Review

Read `agents/adversarial-reviewer.md` and apply its rules to filter and upgrade findings from steps 4.1–4.4. This is the quality gate — it removes weak findings and strengthens strong ones.

---

## Finding Format

Every finding uses this structure:

```markdown
#### [good/improve/fix] Finding title

- **Current**: what exists now in the project
- **Recommendation**: what should change (omit for "good" findings)
- **Project relevance**: why this matters for *this specific project*
- **Source**: [Doc section title](full URL) (via MCP|Playwright CLI)

**URL formatting:** MCP tools return relative paths like `/docs/en/memory`. Always expand these to full URLs: `https://docs.anthropic.com/en/docs/agents/claude-code/memory`. The reader needs clickable links, not internal paths.
```

**Tags:**
- `good` — the project does this well; acknowledge it
- `improve` — not broken, but there's a documented better way
- `fix` — misconfigured, missing something important, or contradicts documentation

---

## Phase 5: Write Report

Write `AUDIT-REPORT.md` to the project root.

```markdown
# Claude Code Audit Report

> Audited: YYYY-MM-DD | Mode: MCP|Playwright CLI
> Project: <name> | Goal: <confirmed goal>

## Current State

| Area | What it is | Status | Findings |
|------|-----------|--------|----------|
| CLAUDE.md | Your project's instructions to Claude | good/improve/fix | N |
| Rules | Targeted instructions scoped to specific files | good/improve/fix | N |
| Skills | Reusable workflows Claude can invoke | good/improve/fix | N |
| Sub-agents | Isolated Claude sessions for specific tasks | good/improve/fix | N |
| Hooks | Automated actions before/after Claude acts | good/improve/fix | N |
| Permissions | What Claude can do without asking | good/improve/fix | N |
| Settings | Project-level Claude Code configuration | good/improve/fix | N |
| MCP | Connections to external tools and services | good/improve/fix | N |
| Features | Overall use of available Claude Code features | good/improve/fix | N |

## Findings

### Instructions (CLAUDE.md + Rules)
<filtered findings from 4.1>

### Components (Skills + Sub-agents)
<filtered findings from 4.2>

### Automation (Hooks + Permissions + Settings)
<filtered findings from 4.3>

### Integration (MCP + Features)
<filtered findings from 4.4>

## Priority Actions

| # | Type | What to do | Why it matters |
|---|------|-----------|----------------|
| 1 | fix | <action> | <reason for this project> |
| 2 | improve | <action> | <reason for this project> |

## Next Steps

To implement these recommendations:
1. Start a new Claude Code session
2. Enter Plan mode (Shift+Tab or /plan)
3. Tell Claude: "Read AUDIT-REPORT.md and create an implementation plan for the priority actions"
4. Review the plan, then execute
```

**Status assignment:**
- `good` = all findings are `good`, or area not in use and that's fine for this project
- `improve` = has `improve` findings but no `fix` findings
- `fix` = has one or more `fix` findings

**Priority Actions:** rank by impact. `fix` items first, then `improve`. Maximum 5 rows.

After writing the report, print a summary to the conversation:

```
Audit complete — report written to AUDIT-REPORT.md.

[X] findings: [Y] good, [Z] to improve, [W] to fix.

Top priorities:
1. ...
2. ...
3. ...
```

---

## Critical Rules

1. **Every finding cites a fetched source.** No URLs from memory. If you can't find documentation to support a finding, drop it entirely.
2. **Phase 3 is mandatory.** Never skip user confirmation, even if you're confident.
3. **Skip unavailable areas.** If all doc fetches for a specialist's domain fail, note "Skipped — documentation unavailable" in the report.
4. **Provenance.** Every source citation ends with `(via MCP)` or `(via Playwright CLI)`.
5. **Plain language.** The reader may not be a developer. Write findings anyone can understand and act on.
6. **Only recommend documented features.** If it's not in the pages you fetched, don't recommend it — you might be hallucinating it.
