# Skills Construction Guide

Reference material for evaluating skill quality. The components specialist reads this when auditing a project's skills.

## Skill File Structure

```
skill-name/
├── SKILL.md          (required — the skill definition)
├── scripts/          (optional — executable code for deterministic tasks)
├── references/       (optional — docs loaded into context on demand)
└── assets/           (optional — templates, icons, fonts)
```

## SKILL.md Anatomy

### Frontmatter (required)

```yaml
---
name: skill-name
description: "What the skill does and when to use it. Include trigger phrases."
---
```

**name** — identifier for the skill. Short, kebab-case.

**description** — the primary trigger mechanism. Claude reads this to decide whether to invoke the skill. A good description:
- Explains what the skill does (the capability)
- Explains when to use it (the trigger conditions)
- Includes specific phrases a user would say
- Is slightly assertive — Claude tends to undertrigger, so descriptions should actively claim their territory

Good: "Audit a project's Claude Code setup against Anthropic documentation. Use when the user says 'audit', 'review my setup', 'check my config', or wants to evaluate their Claude Code usage."

Bad: "A skill for auditing things."

### Body

Instructions Claude follows when the skill triggers. Key principles:

**Imperative voice** — "Read the config file" not "The config file should be read."

**Explain why** — Claude handles edge cases better when it understands reasoning rather than following rigid rules. "Fetch documentation first because findings must cite real sources — fabricated URLs undermine the entire report" beats "ALWAYS fetch documentation first."

**Progressive disclosure** — Keep SKILL.md under 500 lines. For more content:
- Reference material goes in `references/*.md`
- Executable logic goes in `scripts/`
- Point to these files from SKILL.md with clear guidance on when to read them

**Examples** — Include examples for complex output formats or non-obvious patterns. A good example saves paragraphs of explanation.

## Common Quality Issues

### Trigger Problems

| Problem | Symptom | Fix |
|---------|---------|-----|
| Undertriggering | Skill exists but Claude rarely uses it | Make description more specific, add trigger phrases |
| Overtriggering | Skill fires on unrelated prompts | Narrow description, add exclusion notes |
| Vague description | Triggers inconsistently | Add concrete phrases and contexts |

### Content Problems

| Problem | Symptom | Fix |
|---------|---------|-----|
| Too long | Slow to load, dilutes key instructions | Move reference material to separate files |
| Too rigid | "ALWAYS/NEVER" everywhere, brittle | Explain reasoning so Claude can adapt |
| Too vague | Claude doesn't know what to do | Add specific steps, examples, output formats |
| No examples | Output format inconsistent | Add 2-3 examples of expected output |
| Stale content | References outdated APIs or patterns | Audit against current documentation |

### Structure Problems

| Problem | Symptom | Fix |
|---------|---------|-----|
| No entry point | Claude doesn't know where to start | Add a workflow section at the top |
| Monolithic | Everything in one massive file | Split into SKILL.md + references/ |
| Missing frontmatter | Skill never triggers | Add name and description fields |

## Skill vs Sub-agent

| Use a skill when... | Use a sub-agent when... |
|---------------------|------------------------|
| Instructions run in the main conversation | Work runs independently in its own context |
| Steps are sequential and dependent | Tasks are parallel and independent |
| Output feeds into the conversation | Output is a standalone artefact |
| User needs to interact during execution | Task runs without user input |

## Evaluation Checklist

When auditing a skill:

1. **Does it trigger?** — Is the description specific enough with real trigger phrases?
2. **Does it deliver?** — Walk through the instructions. Are there gaps, ambiguities, dead ends?
3. **Right size?** — Under 500 lines? Uses references for bulk content?
4. **Explains why?** — Can Claude handle edge cases from understanding, or only from rote rules?
5. **Maintained?** — Does it reference current features and APIs, or is it stale?
6. **Right container?** — Should this be a skill, a sub-agent, a rule, or just CLAUDE.md content?
