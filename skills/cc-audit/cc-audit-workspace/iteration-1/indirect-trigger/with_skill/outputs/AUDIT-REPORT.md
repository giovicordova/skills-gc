# Claude Code Audit Report

> Audited: 2026-04-04 | Mode: MCP
> Project: skills-gc | Goal: A skills-only repository containing 6 Claude Code skill definitions. Audit evaluates whether the project makes effective use of Claude Code features to support skill development and testing.

## Current State

| Area | What it is | Status | Findings |
|------|-----------|--------|----------|
| CLAUDE.md | Your project's instructions to Claude | fix | 1 |
| Rules | Targeted instructions scoped to specific files | improve | 1 |
| Skills | Reusable workflows Claude can invoke | good | 3 |
| Sub-agents | Isolated Claude sessions for specific tasks | good | 0 |
| Hooks | Automated actions before/after Claude acts | good | 0 |
| Permissions | What Claude can do without asking | fix | 1 |
| Settings | Project-level Claude Code configuration | improve | 1 |
| MCP | Connections to external tools and services | good | 0 |
| Features | Overall use of available Claude Code features | improve | 1 |

## Findings

### Instructions (CLAUDE.md + Rules)

#### [fix] No CLAUDE.md file exists

- **Current**: The project has no CLAUDE.md at the root, in `.claude/`, or in any subdirectory. Claude starts every session on this repo with zero persistent context about the project.
- **Recommendation**: Create a `CLAUDE.md` at the project root. It should cover: what this repo is (a library of Claude Code skills), how skills are structured (each skill is a directory with `SKILL.md` plus optional supporting files), how to install skills (symlink to `~/.claude/skills/`), the naming and frontmatter conventions used across all skills, and the testing approach (each skill has an `evals/` directory). Keep it under 200 lines.
- **Project relevance**: This is a skills *authoring* project. Without a CLAUDE.md, every session starts blind to the conventions that make these skills consistent -- frontmatter patterns, description writing style, directory structure, and testing expectations. Claude will reinvent these conventions each time instead of following established ones.
- **Source**: [How Claude remembers your project](https://docs.anthropic.com/en/docs/agents/claude-code/memory) -- "Every project using Claude Code benefits from a CLAUDE.md -- it's Claude's only persistent memory of the project across sessions." (via MCP)

#### [improve] No rules directory for skill-writing conventions

- **Current**: No `.claude/rules/` directory exists. All 6 skills follow similar patterns (YAML frontmatter, description with trigger phrases, imperative body) but these conventions are not documented anywhere Claude can see.
- **Recommendation**: Create `.claude/rules/skill-authoring.md` scoped to `**/SKILL.md` files. Include: required frontmatter fields, description writing patterns (what + when + trigger phrases), body style (imperative, explain why, progressive disclosure), line limit guidance. This ensures consistency across all skills without loading these rules when working on non-skill files.
- **Project relevance**: Six skills need to follow the same authoring conventions. Today, consistency depends on the user remembering and enforcing patterns manually each session. A scoped rule would make Claude enforce them automatically when editing any SKILL.md.
- **Source**: [Organize rules with .claude/rules/](https://docs.anthropic.com/en/docs/agents/claude-code/memory#organize-rules-with-clauderules) -- "Rules can be scoped to specific files using YAML frontmatter with the paths field. These conditional rules only apply when Claude is working with files matching the specified patterns." (via MCP)

### Components (Skills + Sub-agents)

#### [good] Skills have complete, well-written frontmatter

- **Current**: All 6 skills include `name` and `description` in YAML frontmatter. Descriptions are detailed and include specific trigger phrases (e.g., checkpoint lists "checkpoint", "end of session", "save session", "wrap up", "save progress"). This is exactly what the documentation recommends for reliable skill triggering.
- **Project relevance**: Since this repo exists to produce high-quality skills, the skills themselves serve as proof of concept. The frontmatter quality here is a template other skill authors can follow.
- **Source**: [Extend Claude with skills -- Frontmatter reference](https://docs.anthropic.com/en/docs/agents/claude-code/skills) -- "Only description is recommended so Claude knows when to use the skill." (via MCP)

#### [good] Advanced skill features used appropriately

- **Current**: The perspective skill uses `context: fork`, `disable-model-invocation: true`, and `allowed-tools` to run in an isolated sub-agent context with controlled tool access. The website-audit skill uses `context: fork` with specific MCP tool references and `Agent()` tool access. These are documented advanced patterns applied where they make sense -- perspective needs web research in isolation, website-audit needs browser tools.
- **Project relevance**: Demonstrates that these skills go beyond basic slash commands and use the full skill capability surface. This is the standard the other skills should aspire to where appropriate.
- **Source**: [Run skills in a subagent](https://docs.anthropic.com/en/docs/agents/claude-code/skills#run-skills-in-a-subagent) -- "Add context: fork to your frontmatter when you want a skill to run in isolation." (via MCP)

#### [good] Supporting files used for progressive disclosure

- **Current**: The cc-audit skill uses an `agents/` directory with 5 supporting markdown files (instructions-specialist.md, components-specialist.md, etc.) that are referenced from SKILL.md but only loaded when needed. This keeps the main SKILL.md focused while enabling deep, specialist analysis.
- **Project relevance**: This is exactly the pattern the skills documentation recommends. Reference supporting files from SKILL.md so Claude knows what each file contains and when to load it. The cc-audit skill is the strongest example of this pattern in the repo.
- **Source**: [Add supporting files](https://docs.anthropic.com/en/docs/agents/claude-code/skills#add-supporting-files) -- "Keep SKILL.md under 500 lines. Move detailed reference material to separate files." (via MCP)

### Automation (Hooks + Permissions + Settings)

#### [fix] Stale permission rules in settings.local.json

- **Current**: `.claude/settings.local.json` contains 4 allow rules that reference `/Users/giovannicordova/Documents/02_projects/minimal-framework/` -- a path that does not match this project's location (`skills-gc`). These appear to be leftover from a previous project name or directory structure.
- **Recommendation**: Update the paths to reference `skills-gc` instead of `minimal-framework`. The allow rules should permit symlink operations to/from the correct project directory. Alternatively, use a more general pattern if the skill directories might move.
- **Project relevance**: These rules currently do nothing useful. Any attempt to run the symlink install commands using these allow rules will reference the wrong directory. A user trying to install skills via the README instructions would still get permission prompts.
- **Source**: [Configure permissions](https://docs.anthropic.com/en/docs/agents/claude-code/permissions) -- "Allow rules let Claude Code use the specified tool without manual approval." (via MCP)

#### [improve] No shared project settings file

- **Current**: The project has only `.claude/settings.local.json` (gitignored). There is no `.claude/settings.json` that would be shared via version control.
- **Recommendation**: Create `.claude/settings.json` with shared project settings. At minimum, move the skill installation allow rules here (with corrected paths) so they benefit anyone working on the repo, not just one machine. This also establishes the settings file as the place to add future project-level configuration.
- **Project relevance**: The README instructs users to install skills via symlinks. Having shared permission rules for those symlink commands would make installation frictionless for any contributor.
- **Source**: [Claude Code settings -- Configuration scopes](https://docs.anthropic.com/en/docs/agents/claude-code/settings) -- "Project scope: .claude/ in repository. All collaborators on this repository. Yes (committed to git)." (via MCP)

### Integration (MCP + Features)

#### [improve] Underusing Claude Code features for a project that teaches them

- **Current**: Of the 9 audit areas, only Skills are actively configured. CLAUDE.md, Rules, Hooks, Permissions, Settings, MCP, and Sub-agents are either absent or misconfigured. The project has no shared settings, no project-level instructions, and no automation.
- **Recommendation**: Add CLAUDE.md (priority 1) and a scoped rule for SKILL.md authoring (priority 2). These two changes cover the highest-impact gaps. Hooks, MCP, and sub-agents are not necessary for a markdown-only skill library and should not be added just for the sake of completeness.
- **Project relevance**: This repository is a reference collection of Claude Code skills. It would be stronger if it also demonstrated good Claude Code project setup practices. A visitor looking at this repo to learn about skills would also see how CLAUDE.md and rules complement them -- making the repo itself a teaching example.
- **Source**: [Extend Claude Code -- Match features to your goal](https://docs.anthropic.com/en/docs/agents/claude-code/features-overview) -- "CLAUDE.md for project conventions, 'always do X' rules" and "Use rules to keep CLAUDE.md focused. Rules with paths frontmatter only load when Claude works with matching files, saving context." (via MCP)

## Priority Actions

| # | Type | What to do | Why it matters |
|---|------|-----------|----------------|
| 1 | fix | Create `CLAUDE.md` with project overview, skill structure conventions, install instructions, and authoring standards | Every session starts blind without it. This is the single change that improves every future interaction with this repo. |
| 2 | fix | Update `.claude/settings.local.json` paths from `minimal-framework` to `skills-gc` | Current allow rules point to a non-existent path. Skill installation via symlinks fails silently. |
| 3 | improve | Create `.claude/settings.json` with shared permission rules for skill symlink installation | Makes the install workflow frictionless for anyone, not just one machine. |
| 4 | improve | Add `.claude/rules/skill-authoring.md` scoped to `**/SKILL.md` | Enforces consistent skill quality across all 6 skills automatically. |
| 5 | improve | Treat the repo itself as a showcase of good Claude Code setup | A skills library that demonstrates CLAUDE.md + rules + skills together is more credible than one using skills alone. |

## Next Steps

To implement these recommendations:
1. Start a new Claude Code session
2. Enter Plan mode (Shift+Tab or /plan)
3. Tell Claude: "Read AUDIT-REPORT.md and create an implementation plan for the priority actions"
4. Review the plan, then execute
