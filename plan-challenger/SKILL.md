---
name: plan-challenger
description: "Stress-test and improve implementation plans before execution. Researches alternatives, challenges complexity, checks modularity and feasibility, then delivers a full revised plan. Use whenever the user has a plan — any format (PLAN.md, inline, pasted, attached) — and wants it reviewed before starting. Trigger on 'review this plan', 'challenge this plan', 'stress test', 'is this plan good', 'before we start', 'check the plan', or any request to validate or improve an implementation plan. Also use when the user seems hesitant about a plan or asks 'does this make sense'. Even if the user just says 'plan-challenger' or 'challenge it', invoke this skill."
argument-hint: "[optional: specific aspect to focus on, e.g. 'simplification only' or 'check the ordering']"
---

# Plan Challenger

Pressure-test a plan before a single line of code is written. Fixing a plan costs minutes. Fixing an implementation costs hours.

## Why this matters

Most plan reviews are static — they eyeball the steps and flag obvious issues. This skill goes further: it actively researches alternatives, checks whether libraries already solve what the plan proposes to build, and forecasts maintainability as the project grows. The output isn't just a list of problems — it's a complete revised plan ready to execute.

## How to analyse the plan

Before writing anything, understand what you're looking at:

- **The goal** — what is the plan trying to achieve? Strip away the steps and find the core ask.
- **The constraints** — stack, team size, timeline, existing code. Don't challenge these unless they're wrong.
- **The format** — file path, inline plan, pasted document. Accept any format.

If the plan isn't obvious from context, ask: "Which plan should I review?"

If the plan references existing code, **read that code first**. You cannot challenge assumptions about code you haven't seen.

## Steps

### 1. Receive and understand the plan

Read the plan fully. If $ARGUMENTS specifies a focus area (e.g. "simplification only"), narrow the analysis to that dimension. Otherwise, work through all applicable dimensions.

### 2. Research

This step is mandatory — never skip it. Most plan reviews fail because they don't check what already exists.

- **Existing solutions**: Do libraries, tools, or built-in features already handle parts of this plan? Search npm, PyPI, GitHub, official docs. A plan that says "build a custom X" when a well-maintained library does X is wasting time.
- **Technical assumptions**: The plan says "we need to do Y" — is that actually true? Check the docs. Maybe the framework already handles it.
- **Prior art**: Has someone published a guide, pattern, or solution for this exact problem?

Use web search and documentation lookup tools. Don't speculate — verify.

### 3. Analyse across dimensions

Work through each dimension. Skip what's irrelevant — not every plan needs all eight. But be thorough on what matters.

**Goal alignment** — Does every step serve the stated goal? Plans drift. A feature request becomes an architecture overhaul. A bug fix becomes a refactor. If the goal itself is unclear, flag that first.

**Simplification** — The most common flaw in AI-generated plans. Look for: steps that can be collapsed, unnecessary abstractions, configuration nobody asked for, "nice to have" disguised as requirements, defensive code for impossible scenarios. Ask: what is the minimum set of steps that delivers the goal?

**Modularity and dependencies** — Are steps properly decomposed? Could any run in parallel? Are dependencies between steps explicit or hidden? Would reordering reduce risk?

**Risk and feasibility** — Identify the riskiest step. Check unvalidated assumptions. Find the point of no return. Assess blast radius if a step fails.

**Over-engineering** — Premature abstractions, unnecessary indirection, gold-plating (comprehensive tests for trivial code, docs for internal functions), technology overkill (database when a file works, microservices when a module works).

**Missing pieces** — Prerequisites the plan assumes but doesn't mention. Integration points between steps. Edge cases. Cleanup or rollback plans. Verification steps.

**Ordering** — Fail fast (riskiest step early). Quick wins first. Dependency-driven sequence over "logical" sequence.

**Maintainability forecast** — What happens when the project grows? Will this plan's choices scale to 2x, 5x, 10x the current size? Flag anything that works now but creates debt later.

### 4. Write the report

Print the report directly in the conversation.

**Part 1 — Verdict.** One line. Use one of:
- **READY** — Minor suggestions only. Safe to execute as-is.
- **REVISE** — Has real issues that will cost time if not fixed. Use the revised plan below.
- **RETHINK** — Fundamental problems with approach. The revised plan below takes a different direction.

**Part 2 — Findings.** Group by severity. Each finding states what's wrong, why it matters, and what to do instead.

```
**Critical** — Will cause failure, major rework, or wasted effort
**Warning** — Significant inefficiency or risk worth addressing
**Suggestion** — Improvement that won't block success
```

Be specific. "This could be simpler" is worthless. "Steps 3-5 can be replaced by using `pathlib.Path.rename()` with the `missing_ok` parameter" is useful.

If a dimension has no issues, skip it. Don't pad findings to look thorough.

**Part 3 — Revised plan.** The full plan, rewritten with all improvements applied. Not a diff, not patches — the complete plan ready to execute. The user should be able to take this and start working immediately.

If the original plan is genuinely good, say so and present it mostly unchanged with minor tweaks noted. But this is rare.

### Writing rules

**Be concrete.** Every finding must include a specific action. Every claim must be verifiable. File names, function names, library names, version numbers.

**Never skip research.** If you don't search, you're just a more structured version of a generic reviewer. The research step is what makes this skill worth using.

**Respect the user's stack.** Don't suggest switching languages, frameworks, or paradigms unless they asked. Work within their constraints.

**Read before you challenge.** If the plan references existing code, read it. If it references a library, check its docs. Uninformed criticism is worse than no criticism.

**Don't invent problems.** If the plan is good, say so. Padding the report to look thorough wastes the user's time and erodes trust.
