---
name: perspective
description: "Strategic reality check for any project. Researches whether the solution already exists, whether there are better approaches, and whether the codebase follows current best practices — using live documentation, not stale training data. Use this skill when the user says 'perspective', 'am I on the right track?', 'is there a better way?', 'has someone already built this?', 'reality check', or any request to evaluate whether the current project direction is optimal. Also use when the user questions whether they are reinventing the wheel, wonders about alternatives, or wants to validate architecture against what exists in the ecosystem."
argument-hint: "[quick <topic> | focus area]"
disable-model-invocation: true
context: fork
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - WebSearch
  - WebFetch
  - mcp__plugin_context7_context7__resolve-library-id
  - mcp__plugin_context7_context7__query-docs
---

# Perspective

Give a project a strategic reality check. Build the right thing, the right way, before building it fast.

Time is the most expensive resource. This skill reality-checks projects at three levels:

1. **Does the solution already exist?**
2. **Are there better approaches?**
3. **Is the code following current best practices?** (not training-data-stale knowledge)

Catching a wrong direction early — when changing course is cheap — is the whole point.

## Quick mode

If `$ARGUMENTS` starts with `quick`, run this lightweight check and stop. Do not continue to Stage 1 or create any files.

**Extract the topic:** everything after `quick` in `$ARGUMENTS`. Example: `/perspective quick auth setup` → topic is `auth setup`.

### Step 1: Read relevant code

Use Grep, Glob, and Read to find code related to the topic. Read 3–8 files — enough to understand the area, not the entire codebase.

### Step 2: Check live docs

Use Context7 MCP to pull current documentation for relevant dependencies:
- Resolve the library first (`resolve-library-id`), then fetch docs focused on the topic (`query-docs`)
- Check 1–3 dependencies max
- Skip if the topic is purely about project structure with no external dependency involvement

### Step 3: Respond inline

Structure your response as:

1. **What's there** — 2–4 sentence summary of current code and approach
2. **What's worth knowing** — relevant live docs info: deprecations, better patterns, version mismatches, or current recommendations. Skip if nothing notable.
3. **Recommendations** — concrete suggestions ordered by impact. Name files, functions, patterns, and alternatives. If everything looks good, say so.

Keep concise. No headers larger than bold text. No file output. Respond directly and stop.

---

## Full mode

If `$ARGUMENTS` does not start with `quick`, run all 6 stages. Stages 1–5 always run. Stage 6 is optional and user-triggered.

If `$ARGUMENTS` contains a focus area (e.g., `/perspective authentication`), narrow all stages to that specific area instead of the whole project.

---

## Stage 1: Understand the scope

### Check for previous reports

If a `perspective/` directory exists, read all reports inside it. Note what was already researched, recommended, and implemented (checked-off items). Use this to avoid duplicating research and to focus on what's new.

### Read project context

Look for and read whichever exist:
- `README.md`, `CLAUDE.md`, `VISION.md`, `PROJECT.md`
- `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`
- Any `.planning/` directory contents

Scan the project structure — run `ls` on the root and key directories to understand the codebase shape.

### Summarise to the user

In 3–5 sentences, cover:
- What the project does
- Core approach or architecture
- Key technologies and dependencies
- What stage it's at (early idea, mid-build, mature)

> "Here's what I'm seeing: [summary]. Moving to research — interrupt me if this is off."

Do not wait for confirmation. Keep going.

## Stage 2: Research the landscape

Search the web thoroughly, answering three questions:

1. **Does something identical already exist?** Search using different phrasings for the project's core purpose. Look for open-source projects, commercial products, and established libraries solving the same problem.

2. **Are there better approaches?** Search for how others solved similar problems. Look for architectural patterns, framework choices, and design decisions that differ from the project's.

3. **What's the current state of the art?** Search for recent best practices, blog posts, and discussions about the technologies being used. Focus on content from the last 6–12 months.

**Search strategy:**
- Use at least 5–6 different search queries with varying phrasing
- Search for the problem being solved, not just the solution being built
- Search for alternatives to specific libraries and frameworks
- Check GitHub for similar repositories (stars, activity, recency)

If previous reports exist, skip research areas already covered. Focus on what's new — changes since the last report, newly available alternatives, unexplored areas.

Collect everything. Don't filter yet — that's for the report.

## Stage 3: Coherency analysis

Check whether the codebase is internally healthy before auditing against external best practices. Structural issues that waste effort, create confusion, or make changes harder.

Scan for these categories:

- **Duplication** — code doing the same thing in multiple places. Repeated logic, near-identical functions, copy-pasted patterns with minor variations.
- **Overlapping responsibilities** — modules or files owning the same concern. Competing abstractions, multiple entry points for the same operation.
- **Unnecessary complexity** — abstraction layers that don't earn their cost. Wrapper classes adding no value, over-engineered patterns for simple problems, indirection obscuring what code does.
- **Dead code** — code never called, features behind flags that will never ship, commented-out blocks left indefinitely.
- **Inconsistent patterns** — the same kind of problem solved different ways. Mixed error handling, inconsistent naming, competing approaches to shared concerns.

Focus on what matters most — identify patterns with the biggest impact on maintainability and velocity. Don't catalogue every instance.

If previous reports exist, check whether coherency issues were already flagged. Focus on new findings or worsening issues.

## Stage 4: Audit the codebase

Use Context7 MCP (`resolve-library-id` then `query-docs`) to pull live, version-specific documentation for 3–5 key dependencies. Compare what the code does against current docs recommendations.

What to check:
- Are the APIs being called still the recommended way, or deprecated in newer versions?
- Are there newer, simpler patterns replacing what the code does?
- Are dependency versions current, or pinned to old releases with known issues?
- Have configuration patterns or project structures changed in recent versions?

Prioritise frameworks, core libraries, and anything the architecture depends on heavily.

If Context7 is unavailable, use web search to pull up latest documentation. The audit still happens — it's just less automated.

## Stage 5: Report

Create the `perspective/` directory in the project root if it doesn't exist.

Write to `perspective/{YYYY-MM-DD}-perspective-report.md`. If a report with today's date exists, append a number (e.g., `2026-04-04-perspective-report-2.md`).

### Report structure

```markdown
# Perspective Report — {Project Name}
> {Date}

## What You're Building
{2–3 sentence summary of the project scope and approach.}

## What Already Exists
{Similar or identical projects/tools/libraries found during research. For each:}
- **Name** — what it is, how it compares, link
{Be direct: if something is essentially the same thing, say so.}
{If nothing similar exists, say that clearly — it's valuable information.}

## Alternative Approaches
{Different ways to solve the same problem. For each:}
- What the approach is
- How it differs from the current one
- Trade-offs (what you gain, what you lose)

## Codebase Audit
{Findings from the Context7/docs audit:}
- What's current and solid
- What's outdated or deprecated, with the current recommended replacement
- Dependency versions worth updating

## Coherency
{Internal structural issues from the coherency analysis.}
{Skip categories with no findings. Prioritise by impact on maintainability.}

## Recommendation
{One of:}
- **Stay the course** — the approach is sound, here's why
- **Adjust** — mostly right but these specific things should change
- **Pivot** — a fundamentally better option exists, here's what and why
- **Adopt** — something already built does this well enough, here's what to use

### Action Items
- [ ] {Concrete fix 1 — specific enough to implement without decisions}
- [ ] {Concrete fix 2}
- [ ] {Concrete fix 3}

{If a recommendation requires architectural decisions or significant design work, list it as a regular bullet point (not a checkbox) and note that it needs a separate planning session.}

> After implementing action items, update this file: `- [ ]` → `- [x]`
```

### Report tone

- **Direct and honest.** If the project is reinventing something that exists, say so without softening.
- **Specific.** Don't say "consider alternatives" — name them, link them, compare them.
- **Respectful of the work done.** Acknowledge what's good before pointing out what could be better.

## Stage 6: Implement

After presenting the report summary, ask:

> "Want me to implement these fixes?"

**If no:** end. The report stands on its own.

**If yes:**
1. Work through each checkbox item in the Action Items, one at a time
2. After completing each fix, update the report — change `- [ ]` to `- [x]`
3. When done, show a brief summary of what changed

**Scope guard:** only implement concrete, well-defined fixes — config changes, dependency updates, code pattern fixes, file restructuring. If something requires architectural decisions or significant design work, skip it, leave it unchecked, and tell the user it needs its own session.
