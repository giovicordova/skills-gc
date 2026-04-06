# Claude Code Audit Report

> Audited: 2026-04-04 | Mode: MCP
> Project: skills-gc | Goal: A collection of 6 Claude Code skills (checkpoint, verify, plan-challenger, perspective, cc-audit, website-audit) intended to be reusable, well-tested skill definitions that enhance Claude Code workflows.

## Current State

| Area | What it is | Status | Findings |
|------|-----------|--------|----------|
| CLAUDE.md | Your project's instructions to Claude | fix | 1 |
| Rules | Targeted instructions scoped to specific files | improve | 1 |
| Skills | Reusable workflows Claude can invoke | good | 1 |
| Sub-agents | Isolated Claude sessions for specific tasks | good | 1 |
| Hooks | Automated actions before/after Claude acts | good | 1 |
| Permissions | What Claude can do without asking | fix | 1 |
| Settings | Project-level Claude Code configuration | improve | 1 |
| MCP | Connections to external tools and services | good | 1 |
| Features | Overall use of available Claude Code features | improve | 1 |

## Findings

### Instructions (CLAUDE.md + Rules)

#### [fix] No CLAUDE.md file exists

- **Current**: The project has no CLAUDE.md at the root, at `.claude/CLAUDE.md`, or in any subdirectory. Claude starts every session on this repo with zero persistent context about what the project is, how it is structured, or what conventions the skills follow.
- **Recommendation**: Create a `CLAUDE.md` at the project root. It should cover: (1) what this repo is -- a collection of Claude Code skills installed via symlink, (2) the standard structure each skill follows (SKILL.md + evals/ + optional agents/ and references/), (3) conventions for writing SKILL.md frontmatter (name, description, argument-hint), (4) how to test skills (the evals pattern), and (5) common commands like `ln -s` for installation. Keep it under 200 lines. Run `/init` to generate a starting point, then refine.
- **Project relevance**: This is the single highest-impact change. Every time you open a Claude Code session on this repo, Claude has to rediscover the project from scratch -- reading README.md, guessing at conventions, not knowing the skill structure. A CLAUDE.md eliminates that cold-start penalty entirely. For a repo whose entire purpose is to define Claude Code skills, not having Claude Code's own memory feature configured is a significant gap.
- **Source**: [CLAUDE.md files](https://docs.anthropic.com/en/docs/agents/claude-code/memory) (via MCP)

#### [improve] No rules directory for skill-authoring conventions

- **Current**: The `.claude/rules/` directory does not exist. All skill directories follow a consistent pattern (SKILL.md with YAML frontmatter, evals/ directory, optional agents/ and references/), but this pattern is not codified anywhere Claude can reference per file type.
- **Recommendation**: Create `.claude/rules/` with at least one rule scoped to `**/SKILL.md` files. This rule should specify: required frontmatter fields (name, description), recommended description patterns (include trigger phrases), maximum line count (~500), and the imperative instruction style each skill should use. This keeps CLAUDE.md focused on project-level context and moves file-specific conventions to where they load automatically when Claude edits a SKILL.md.
- **Project relevance**: You have 6 skills and are likely to add more. A path-scoped rule ensures every new skill follows the same conventions without you having to repeat yourself. It also loads only when Claude is working on SKILL.md files, keeping context lean otherwise.
- **Source**: [Organize rules with .claude/rules/](https://docs.anthropic.com/en/docs/agents/claude-code/memory#organize-rules-with-clauderules) (via MCP)

### Components (Skills + Sub-agents)

#### [good] Skills are well-structured with strong frontmatter

- **Current**: All 6 skills have properly formatted YAML frontmatter with `name`, `description`, and (where appropriate) `argument-hint`. Descriptions are detailed and include specific trigger phrases (e.g., checkpoint lists "end of session", "save session", "wrap up"). The skills use imperative instructions, explain their reasoning, and follow progressive disclosure -- keeping SKILL.md focused with reference material in separate files where needed (e.g., cc-audit's `agents/` directory).
- **Project relevance**: This is the core product of the repo and it is done right. The description quality is particularly strong -- descriptions actively claim their territory with multiple trigger phrases, which is exactly what prevents the common undertriggering problem where Claude skips skills.
- **Source**: [Extend Claude with skills](https://docs.anthropic.com/en/docs/agents/claude-code/skills) (via MCP)

#### [good] Sub-agents in cc-audit are well-designed

- **Current**: The cc-audit skill uses 5 agent instruction files in its `agents/` directory (instructions-specialist, components-specialist, automation-specialist, integration-specialist, adversarial-reviewer). Each has a clear, focused role, specifies what to evaluate, defines expected output format, and is self-contained. The adversarial-reviewer acts as a quality gate with explicit removal and upgrade rules.
- **Project relevance**: This is a textbook use of the sub-agent pattern -- parallel specialist analysis followed by adversarial review. The agents directory is part of the cc-audit skill's supporting files rather than project-level `.claude/agents/`, which is the correct placement since these agents are internal to the skill, not general-purpose project workers.
- **Source**: [Create custom subagents](https://docs.anthropic.com/en/docs/agents/claude-code/sub-agents) (via MCP)

### Automation (Hooks + Permissions + Settings)

#### [good] No hooks is the right call for this project

- **Current**: No hooks are configured in any settings file.
- **Project relevance**: This is a markdown-only skills repository. There are no build steps, no compilation, no deployment targets, no formatters to run after edits. Hooks would add configuration overhead with no practical benefit. If the project later adds code (scripts, tests), hooks for auto-formatting or validation would become relevant, but not now.
- **Source**: [Automate workflows with hooks](https://docs.anthropic.com/en/docs/agents/claude-code/hooks-guide) (via MCP)

#### [fix] Stale permission rules in settings.local.json

- **Current**: `.claude/settings.local.json` contains 4 allow rules that reference paths to `/Documents/02_projects/minimal-framework/` -- a directory name that does not match this project's current location (`skills-gc`). These appear to be leftover from a rename or restructure. The rules allow `rm -rf` and `ln -s` for checkpoint and verify skill symlinks, but point to the wrong source directory.
- **Recommendation**: Update the paths in `settings.local.json` to reference `/Users/giovannicordova/Documents/02_projects/skills-gc/` instead of `minimal-framework`. Also consider adding allow rules for the other 4 skills (plan-challenger, perspective, cc-audit, website-audit) so all skills can be symlinked without permission prompts.
- **Project relevance**: These stale paths mean the permission rules do nothing -- Claude will still prompt when trying to symlink skills. Since symlinking skills into `~/.claude/skills/` is a core workflow for this repo, having working permission rules matters here.
- **Source**: [Configure permissions](https://docs.anthropic.com/en/docs/agents/claude-code/permissions) (via MCP)

#### [improve] No project-level settings.json

- **Current**: The project has `.claude/settings.local.json` (personal, gitignored) but no `.claude/settings.json` (shared, committable). There is no shared project configuration that would persist across collaborators or machines.
- **Recommendation**: Create `.claude/settings.json` with at minimum: (1) updated permission allow rules for symlinking all 6 skills, and (2) any project-wide settings that should be consistent (e.g., `autoMemoryEnabled` preference). Move the symlink permissions from `settings.local.json` to the shared file so anyone cloning this repo gets them.
- **Project relevance**: As a skills repo designed to be cloned and used, shared settings make the setup experience smoother. A new user cloning the repo would currently get no Claude Code configuration at all -- no permissions, no settings, nothing. A committed `settings.json` with the symlink permissions pre-configured reduces setup friction.
- **Source**: [Claude Code settings](https://docs.anthropic.com/en/docs/agents/claude-code/settings) (via MCP)

### Integration (MCP + Features)

#### [good] No MCP servers is appropriate

- **Current**: No `.mcp.json` file exists and no MCP servers are configured at any scope.
- **Project relevance**: This project has no external dependencies, no databases, no APIs, no cloud services. It is a collection of markdown files. MCP servers would add configuration complexity with no benefit. The Anthropic Docs MCP server is useful when *running* the cc-audit skill, but that belongs in the user's global config -- not in this project's config.
- **Source**: [Connect Claude Code to tools via MCP](https://docs.anthropic.com/en/docs/agents/claude-code/mcp) (via MCP)

#### [improve] Feature adoption is minimal for a Claude Code skills project

- **Current**: Of the 9 auditable Claude Code features, this project uses only Skills (as the product) and Sub-agents (within cc-audit). It does not use CLAUDE.md, Rules, Hooks, Permissions (working ones), Settings (shared), MCP, or Plugins. For most projects, using only 2 of 9 features is fine. For a project that is specifically about Claude Code skills, it is an odd gap -- the cobbler's children have no shoes.
- **Recommendation**: Prioritise CLAUDE.md (the cross-cutting fix above), then add a shared `settings.json` with correct permissions, then consider a path-scoped rule for SKILL.md conventions. That takes you from 2 features to 4-5 with minimal effort.
- **Project relevance**: This repo is both a skills product and a demonstration of Claude Code best practices. Users browsing the repo to learn how to build skills will notice the absence of CLAUDE.md and settings -- the two most fundamental features. Adding them improves both the development experience and the repo's credibility as a reference.
- **Source**: [Extend Claude Code](https://docs.anthropic.com/en/docs/agents/claude-code/features-overview) (via MCP)

## Priority Actions

| # | Type | What to do | Why it matters |
|---|------|-----------|----------------|
| 1 | fix | Create a CLAUDE.md at the project root with project identity, skill structure conventions, and key commands | Eliminates cold-start penalty on every session; gives Claude persistent memory of the repo |
| 2 | fix | Update stale paths in `.claude/settings.local.json` from `minimal-framework` to `skills-gc` and add all 6 skills | Makes symlink permissions actually work for the core install workflow |
| 3 | improve | Create `.claude/settings.json` with shared symlink permissions for all skills | Anyone cloning the repo gets working permissions out of the box |
| 4 | improve | Add `.claude/rules/skill-authoring.md` scoped to `**/SKILL.md` with frontmatter and style conventions | Keeps skill quality consistent as the collection grows |
| 5 | improve | Review feature adoption -- CLAUDE.md + settings + rules takes you from 2 to 5 configured features | Matches the project's identity as a Claude Code skills reference |

## Next Steps

To implement these recommendations:
1. Start a new Claude Code session
2. Enter Plan mode (Shift+Tab or /plan)
3. Tell Claude: "Read AUDIT-REPORT.md and create an implementation plan for the priority actions"
4. Review the plan, then execute
