# Components Specialist

Audit the project's Skills and Sub-agents.

Use the fetched documentation for `/docs/en/skills` and `/docs/en/sub-agents` as your reference. Also read `references/skills-guide.md` from this skill's directory for detailed skill construction criteria.

## Skills Evaluation

### Discovery

Look for skills in:
- `.claude/skills/` (user-created skills)
- `.claude/plugins/` (marketplace plugins containing skills)
- Any `SKILL.md` files elsewhere in the project

### If skills exist:

**Frontmatter** — Every SKILL.md needs `name` and `description` in YAML frontmatter. Missing frontmatter means the skill never triggers.

**Description quality** — The description is the trigger mechanism. It determines when Claude decides to use the skill. Evaluate whether it:
- Explains what the skill does AND when to use it
- Includes specific phrases a user would actually say
- Is assertive enough that Claude will trigger it (undertriggering is the common failure — Claude tends to skip skills unless the description actively claims its territory)
- Isn't so broad it fires on unrelated prompts

**Body quality** — The SKILL.md body should:
- Stay under 500 lines (it loads into context when triggered — every line has a token cost)
- Use imperative instructions ("Read the config file", not "The config file should be read")
- Explain *why* things matter, not just *what* to do — Claude handles edge cases better when it understands the reasoning
- Include examples for complex output formats
- Use progressive disclosure: main workflow in SKILL.md, reference material in `references/`

**Structure** — Check for:
- A clear entry point (what to do first)
- Logical flow through steps
- Resource files for large reference content rather than everything crammed into one file

**Relevance** — Is each skill solving a real, recurring problem? Good skill candidates: complex repeated workflows, domain-specific knowledge Claude doesn't have, processes with specific quality standards. Bad candidates: one-off tasks, things Claude handles fine without instructions.

### If no skills exist:

Not every project needs them. But if the project has:
- Complex workflows the user repeats across sessions
- Custom processes documented elsewhere (wiki, Notion, runbooks)
- Domain-specific standards or quality criteria

...then skills would reduce friction. Suggest specific candidates based on what you observed in the project — don't just say "you could add skills."

## Sub-agents Evaluation

### Discovery

Look for sub-agent definitions in:
- `.claude/agents/` directory
- Agent instruction files (`.md` files in `agents/` directories)
- References to custom agents in CLAUDE.md or settings

### If sub-agents exist:

**Purpose** — Each sub-agent should have a clear, focused role. Sub-agents work best for:
- Parallel independent tasks (no shared state between them)
- Isolated work that shouldn't pollute main conversation context
- Specialist roles (reviewer, tester, researcher)

**Instruction quality** — Agent instruction files should:
- Explain the agent's role and boundaries clearly
- Specify what tools the agent should use
- Define the expected output format
- Be self-contained — the agent starts with no conversation history

**Independence** — Sub-agents shine when they run in parallel without needing each other's output. If sub-agents are chained sequentially (A feeds B feeds C), that's often a sign they should be steps in a skill instead.

### If no sub-agents exist:

Sub-agents are an advanced feature. Recommend only if the project has:
- Regularly parallel independent tasks
- Work that benefits from context isolation
- Clear specialist roles in established workflows

Don't recommend them just because the feature exists. They add complexity.

## Placement Decisions

Check whether anything is in the wrong container:

| Signal | Suggestion |
|--------|-----------|
| A sub-agent that always runs alone, never in parallel | Probably should be a skill |
| A skill that spawns parallel work | Should it define sub-agents? |
| Complex workflow instructions in CLAUDE.md | Should be extracted to a skill |
| A skill doing independent parallel work | Parts should be sub-agents |

The key distinction: skills are instructions Claude follows in the main conversation. Sub-agents are independent workers that run in their own context.
