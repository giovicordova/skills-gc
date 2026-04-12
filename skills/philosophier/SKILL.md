---
name: philosophier
description: "Compresses verbose text into the shortest precise phrasing that preserves every constraint and leaves zero ambiguity. Use whenever the user wants to shorten, compress, tighten, distill, or cut down any text — CLAUDE.md sections, README files, AGENTS.md personas, CONTRIBUTING.md, commit messages, error messages, package descriptions, or any prose that says too much with too many words. Also use when writing new documentation content from scratch that should be maximally concise. Trigger phrases: 'philosophier', 'distill this', 'make this shorter', 'compress this', 'tighten this up', 'cut it down', 'too wordy', 'too verbose', 'every line should carry weight', 'say more with less'. If a user pastes a paragraph and asks for it shorter — this is the skill. If they link a file and say it's too long — this is the skill."
argument-hint: "[text to distill, or 'file <path>' to distill a file section]"
---

# Philosophier

Turn long text into short truth. Every word must earn its place.

## The principle

Philosophy's power is compression — centuries of thought reduced to a sentence that changes how someone thinks. This skill applies that same compression to technical writing. The goal is not elegance for its own sake. The goal is clarity at minimum cost.

A good distillation:
- **Carries the full weight of the original** — nothing lost, nothing ambiguous
- **Reads in seconds** — the reader's time is the most expensive resource
- **Leaves no room for misreading** — direct, declarative, one interpretation only
- **Feels inevitable** — as if the short version was always the right one

A bad distillation:
- Sounds clever but means nothing ("Less is more")
- Drops constraints the original carried
- Requires context the reader doesn't have
- Trades precision for poetry

## How to distill

### Step 1: Identify the load-bearing meaning

Read the input. For each paragraph or section, answer: **what does the reader need to know or do?** Strip away:
- Repetition (the same idea said twice with different words)
- Hedging ("it might be worth considering that perhaps...")
- Filler transitions ("additionally", "furthermore", "it is important to note that")
- Explanations of obvious things
- Examples that restate what the rule already said clearly

What remains is the structural meaning — the bones.

### Step 2: Compress to declarative statements

Rewrite each meaning unit as a single declarative statement. Techniques:

**Use imperatives** — "Validate input at boundaries, not everywhere" instead of "You should make sure that input validation happens at the system boundaries rather than adding validation logic throughout the entire codebase."

**Name the tradeoff** — "Brevity without ambiguity" instead of "The text should be short but at the same time it should not leave room for multiple interpretations."

**State the constraint directly** — "British English. Switch to Italian only when addressed in Italian." instead of "The default language should be British English with British spellings like prioritise and colour. You should only switch to Italian when the User writes in Italian."

**Cut the obvious** — if a reader can infer it from context, it doesn't need saying. A CLAUDE.md file doesn't need to explain what CLAUDE.md is.

### Step 3: Verify nothing was lost

Compare each distilled line against the original. Check:
- Does every constraint survive? (languages, formats, conditions)
- Does every trigger survive? (when to do X, when not to)
- Would someone reading only the distilled version behave identically to someone reading the original?

If a distilled line fails this check, it's too compressed. Add back the minimum words needed to restore the meaning.

### Step 4: Test for ambiguity

Read each distilled line as if you've never seen the original. Ask: **could a reasonable person read this differently than intended?** If yes, rephrase until there's only one reading.

## Output format

**If rewriting existing text**, present:

```
### Before
[original text]

### After
[distilled text]

### Dropped
[anything removed that might matter — ask the user if unsure]
```

If multiple sections are distilled, use this format per section. Group them under one response.

**If writing new text**, just write it distilled from the start. No before/after needed.

**If distilling an entire file**, offer to rewrite the file directly after showing the proposed changes.

## Calibration examples

**Verbose:**
> "Whenever you are sure about something but you evaluate that it is something that might have changed in the last few months, use real-time sources to update and look for solutions that might not be part of your training. This, of course, doesn't apply to unchangeable things. But mostly when we are talking about technology and things that are growing fast, this is the case."

**Distilled:**
> "Verify fast-moving claims with live sources. Stable knowledge needs no check."

---

**Verbose:**
> "Your responses should be short and concise. When referencing specific functions or pieces of code include the pattern file_path:line_number to allow the user to easily navigate to the source code location."

**Distilled:**
> "Short replies. Reference code as `file:line`."

---

**Verbose:**
> "If an approach fails, diagnose why before switching tactics — read the error, check your assumptions, try a focused fix. Don't retry the identical action blindly, but don't abandon a viable approach after a single failure either."

**Distilled:**
> "Failure is diagnostic, not decisive. Understand before you pivot."

## Boundaries

- Never sacrifice a constraint for brevity. If a rule has three conditions, all three survive.
- Never distill code, configs, or structured data — only prose.
- If the original text is already concise, say so. Don't compress what's already compressed.
- When in doubt about whether a detail matters, keep it and flag it for the user.
