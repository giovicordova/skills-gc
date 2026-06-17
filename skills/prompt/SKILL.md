---
name: prompt
description: Rewrite the user's rough, spoken-style request into a clean, well-structured Claude prompt, then execute it. The core job is faithful interpretation — restructure what the user actually said, never invent requirements. When the ask has gaps that would change what gets built, close them by asking via interactive-qa, fold the answers in, then run. Trigger when the user appends or prepends `/prompt` to a request, or says "turn this into a good prompt", "fix my prompt", "promptify this", "make this a proper prompt". NOT for compressing finished text (philosophier), redoing Claude's own verbose reply (cut), or auditing output (verify).
---

# Prompt

Turn the user's loose, spoken-style ask into a sharp prompt, surface it, then run it. The job is to interpret faithfully, not to invent. The value is the rewrite the user can catch before the work lands, and the gaps it closes by asking instead of guessing.

## Steps
1. **Find the raw ask.** It's everything in this turn minus the `/prompt` token. Don't strip detail or "improve" the intent.
2. **Spot the gaps.** Read for what's missing, ambiguous, or assumed: unclear target ("it", "the page"), unstated goal, undefined scope, conflicting signals. Sort each gap:
   - **Inferable from context** → fill it, and make the assumption visible in the rewrite so the user can catch it.
   - **Would change what gets built** → don't guess. Collect these and ask.
3. **Ask, if needed.** If any gaps survive Step 2, route them through `interactive-qa` (plain-language questions, your best-guess answer flagged). Fold the answers back into the prompt. If there are no such gaps, skip straight ahead — don't manufacture questions.
4. **Show it.** Print the refined prompt as a short fenced block (`Rewritten prompt:`), 2-6 lines, with any filled-in assumptions stated. No commentary on what you changed.
5. **Execute it.** Carry out the rewritten prompt in the same turn, routing to the right `-gc` agent or skill as usual.

## Guardrails
- **Never invent.** Every requirement in the rewrite traces to something the user said or confirmed. A gap is a question, not a blank to fill with what would sound good.
- **Ask only what changes the work.** The failure mode is interrogating the user over trivia. One vague ask should cost zero or one round of questions, not five. Inferable detail gets filled and shown, not asked.
- **Faithful over clever.** A literal, well-structured version of *their* ask beats an impressive prompt that drifts from it.
- **Rewrite ≠ scope creep.** No "while we're at it" features or constraints the user never raised.
