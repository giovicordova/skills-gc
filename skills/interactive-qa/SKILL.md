---
name: interactive-qa
description: "Interactive Q&A that collects the user's decisions when agents present multiple options or when multiple agents disagree. Produces a short plain-language brief the user can hand to Plan Mode, a specialized agent, or keep in context. Use this skill whenever any agent (or a board-meeting, brainstorming, or pre-plan session) comes back with 2+ reasonable options, trade-offs, or conflicting recommendations that need a human call — the user is not a developer, so options must be in non-technical plain English with the agent's recommendation flagged and any disagreement between agents surfaced. Also trigger on 'ask me', 'Q&A me', 'let me decide', 'collect my decisions', 'interactive Q&A', 'I need to decide', or any moment the current step is blocked waiting on a human decision. Do not guess the user's preference — ask."
---

# Interactive Q&A

Collect the user's decisions through structured Q&A. Turn agent-level trade-offs into plain-language choices the user can answer in seconds.

## When this skill runs

- **Board meetings** — agents have weighed in, views conflict, the user settles it.
- **Brainstorming** — ideas are branching, the user's taste picks the branch.
- **Pre-plan briefs** — before Plan Mode, gather the decisions the plan depends on.
- **Agent stalls** — any agent is blocked on a choice only the user can make.
- **Multi-agent disagreement** — two or more agents argue for different options on the same subject.

If there are 2+ reasonable options on the table, do not guess. Ask.

## Principles

- **Plain language.** The user is not a developer. Describe options like you'd describe them to a smart friend over coffee. No jargon, no acronyms, no framework names unless strictly necessary.
- **Brief.** 1–5 word labels. One-sentence descriptions that name the trade-off in practice.
- **Flag the recommendation.** Put the recommended option first and append "(Recommended)" to the label.
- **Surface disagreement.** When multiple agents disagree, make each agent's preferred option a distinct choice, name the agent in the description ("Marketing says…", "Business says…"), and include at least one compromise option.
- **Don't infer.** If an option is missing, let the user type "Other". Don't fill gaps silently.

## The three steps

### Step 1 — Ask about handoff first

Before any decision questions, ask one AskUserQuestion: where does the brief go when we're done? This shapes the rest of the flow.

Default options (adapt to project):

- **Keep in context (Recommended)** — brief stays inline; the next agent or Claude reads it from the conversation.
- **Feed to a specific agent** — if the project has a specialist ready (e.g. web-developer, editorial, marketing). Name the agent.
- **Enter Plan Mode** — hand the brief straight into Plan Mode as the starting spec.
- **Save to file** — write `BRIEF.md` (or a topic-specific name) in the project root.

If the handoff is already clear from conversation ("then enter plan mode"), skip this call and confirm inline in one sentence.

### Step 2 — Ask the decisions

Use AskUserQuestion, up to 4 questions per call. Batch thematically — don't mix unrelated decisions in one call.

For each question:

- **One clear question** ending in a question mark.
- **2–4 options.** More than 4 means the question is too broad — split it.
- **Recommended option first**, with "(Recommended)" suffix.
- **Option labels: 1–5 words** of plain English.
- **Option descriptions: one sentence** describing what this choice means in practice and the main trade-off.
- **multiSelect: true** only when choices genuinely aren't mutually exclusive.

When agents disagree, format options like this:

> **Marketing's pick (Recommended)** — bold headline, one CTA. Best for conversion. Least visual polish.
> **Business's pick** — lead with logos and reviews. Builds enterprise trust. Slower story.
> **Editorial's pick** — image-led with short tagline. Feels premium, on-brand. Weakest at conversion.
> **Compromise** — bold headline with logos below. Keeps conversion priority, addresses trust. Middle ground.

The user sees at a glance who's arguing for what — and why.

### Step 3 — Produce the brief and hand off

Assemble a short brief. One line per decision. This is a brief, not a report.

```
## Decisions
- [Topic]: [chosen option] — [one-line note if the user added context]
- [Topic]: [chosen option]
- …

## Handoff
[One line: "Stays in context" / "Entering Plan Mode" / "Handing to web-developer agent" / "Saved to BRIEF.md"]
```

Then hand off based on Step 1:

- **Keep in context** — post the brief inline. Stop. The next turn picks it up.
- **Feed to agent** — dispatch the named agent with the brief as the input prompt.
- **Enter Plan Mode** — call EnterPlanMode using the brief as the starting spec.
- **Save to file** — Write the brief to `BRIEF.md` (or `{topic}-brief.md`) at project root. Stop.

## What this skill does not do

- Does not make decisions for the user. When in doubt, ask.
- Does not pad the flow with confirmations ("Got it!", "Great choice!"). Capture, brief, hand off.
- Does not write long reports. The brief is a handoff artefact, not a document.
- Does not re-ask the user things already decided earlier in the conversation.
