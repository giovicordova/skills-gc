---
name: verify
description: Audits Claude's work against the user's original request in the current session. Checks whether the output precisely matches what was asked — structure, styles, content, behaviour, constraints. Use when the user says "verify", "check your work", "did you follow my request", "audit this", or "compliance check". Run this after Claude has delivered work and you want to hold it accountable.
argument-hint: "[optional: specific aspect to focus on, e.g. 'styles only' or 'responsive layout']"
---

# Verify Skill

Audit Claude's session output against the user's original request. No external files, no CLAUDE.md — only the conversation context matters.

## What this does

You re-read the current session from the user's first request to Claude's last action, then produce a structured compliance report. The goal is to catch gaps, drift, and misinterpretations — things Claude did that weren't asked for, things asked for that weren't done, and things done differently from what was specified.

## Instructions

1. **Extract the request.** Go back through the session and identify every concrete requirement the user stated. These come in two forms — treat both equally:

   - **Explicit requirements**: direct instructions like "use a dark background", "make it responsive", "add a hover effect".
   - **Implicit constraints**: qualifiers that set boundaries on how the work should be done. Words like "simple", "minimal", "lightweight", "basic", "quick" are constraints — they mean the output should not be over-engineered. "Like the example I showed you" or "same structure as before" are constraints too.

   List each as a discrete, checkable item. If $ARGUMENTS specifies a focus area, narrow the extraction to that aspect only.

2. **Identify what was delivered.** Find every file Claude wrote, edited, or generated in the session. Read each one. If Claude made multiple revisions, use the latest version of each file.

3. **Compare requirement by requirement.** For each requirement extracted in step 1, check the delivered files:
   - **PASS** — the requirement is fully met. State the evidence (file, line, or behaviour).
   - **PARTIAL** — the requirement is addressed but incomplete or imprecise. State what's missing.
   - **FAIL** — the requirement is not met at all. State what was expected vs. what exists.

   Then scan for **unrequested additions** — anything present in the output that wasn't asked for. For each extra, judge severity:
   - **harmless** — standard boilerplate, doesn't change scope (e.g. a CSS reset, a viewport meta tag).
   - **scope creep** — adds complexity, behaviour, or code the user didn't want (e.g. error handling, validation, logging, documentation when "simple" was specified).
   - **harmful** — actively wrong or counterproductive (e.g. validation that rejects valid input, redundant checks with race conditions).

4. **Write the report.** Print the report directly in the conversation.

   **If everything passes and there are no significant extras**, keep it short:
   ```
   ## Verify: <one-line summary>
   **All X requirements met.** No issues found. <one sentence of evidence summary>
   ```
   Do not write a full table for a clean bill of health. Brevity is the point.

   **If there are any PARTIAL, FAIL, or notable extras**, use the full format:
   ```
   ## Verify: <one-line summary of what was requested>

   **Score: X/Y requirements met** (Z partial)

   ### Requirements

   | # | Requirement | Verdict | Evidence |
   |---|------------|---------|----------|
   | 1 | <requirement> | PASS/PARTIAL/FAIL | <file:line or behaviour> |
   | 2 | ... | ... | ... |

   ### Unrequested additions
   - <what was added> — <harmless / scope creep / harmful: reason>

   ### Verdict
   <1-2 sentences. Answer one question: did Claude do what was asked, no more, no less? If not, what's the most important fix?>
   ```

   Rules:
   - Be blunt. This is an audit, not a compliment sandwich.
   - Evidence must be specific — file names, line numbers, CSS properties, actual values. Not "looks good".
   - If $ARGUMENTS narrowed the scope, only report on that scope. Mention what was excluded.

5. **Offer to fix.** If any requirement is PARTIAL or FAIL, ask: "Want me to fix these?" — then wait. Don't auto-fix.
