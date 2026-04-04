# Claude Code Audit Report

> Audited: 2026-04-04 | Mode: MCP
> Project: skills-gc | Goal: Audit a collection of 6 Claude Code skills to assess how well the project uses Claude Code features for its own development and maintenance.

## Current State

| Area | What it is | Status | Findings |
|------|-----------|--------|----------|
| CLAUDE.md | Your project's instructions to Claude | fix | 1 |
| Rules | Targeted instructions scoped to specific files | improve | 1 |
| Skills | Reusable workflows Claude can invoke | good | 2 |
| Sub-agents | Isolated Claude sessions for specific tasks | improve | 1 |
| Hooks | Automated actions before/after Claude acts | good | 0 |
| Permissions | What Claude can do without asking | fix | 1 |
| Settings | Project-level Claude Code configuration | improve | 1 |
| MCP | Connections to external tools and services | good | 0 |
| Features | Overall use of available Claude Code features | improve | 1 |

## Findings

### Instructions (CLAUDE.md + Rules)

#### [fix] No CLAUDE.md file exists

- **Current**: The project has no CLAUDE.md at the root, in `.claude/`, or in any subdirectory. Claude starts every session on this project with zero persistent context about what it is, how the skills are structured, or what conventions to follow.
- **Recommendation**: Create a `CLAUDE.md` at the project root covering: what this project is (a collection of Claude Code skills), the directory structure convention (each skill is a folder with `SKILL.md` + optional `agents/` and `evals/`), how to install skills (symlinks to `~/.claude/skills/`), and any writing conventions for skill files (e.g., imperative tone, plain language, line length). Keep it under 200 lines.
- **Project relevance**: This is a project *about* Claude Code skills -- it would directly benefit from the feature it helps others use. Every session editing or creating skills currently starts without context about the project's structure and conventions, meaning Claude may produce inconsistent skill formats or miss the established patterns.
- **Source**: [How Claude remembers your project](https://docs.anthropic.com/en/docs/agents/claude-code/memory) (via MCP) -- "Every project using Claude Code benefits from a CLAUDE.md -- it's Claude's only persistent memory of the project across sessions."

#### [improve] No rules directory for file-type-specific guidance

- **Current**: No `.claude/rules/` directory exists. All 6 skills follow a consistent pattern (SKILL.md with frontmatter), but there's no codified guidance for how skill files should be written versus how agent instruction files should be written.
- **Recommendation**: Create `.claude/rules/` with at least one rule scoped to `**/SKILL.md` files that codifies the skill writing conventions: required frontmatter fields, description quality standards, line length targets, tone. A second rule scoped to `**/agents/*.md` could cover agent instruction file conventions.
- **Project relevance**: This project's core output is markdown skill files. Path-scoped rules would ensure Claude follows the project's conventions automatically whenever it creates or edits a skill, without needing to repeat those instructions in every session.
- **Source**: [Organize rules with .claude/rules/](https://docs.anthropic.com/en/docs/agents/claude-code/memory#organize-rules-with-clauderules) (via MCP) -- "Rules can be scoped to specific file paths, so they only load into context when Claude works with matching files, reducing noise and saving context space."

### Components (Skills + Sub-agents)

#### [good] Well-structured skills with strong frontmatter

- **Current**: All 6 skills have proper YAML frontmatter with `name` and `description` fields. Descriptions are detailed and include multiple trigger phrases (e.g., checkpoint lists "checkpoint", "end of session", "save session", "wrap up", "save progress"). Two skills (perspective, website-audit) use advanced frontmatter features like `context: fork`, `disable-model-invocation`, and `allowed-tools`.
- **Project relevance**: This is a skill library -- the skills themselves are the product. They follow the documented best practices for discoverability and invocation control.
- **Source**: [Extend Claude with skills](https://docs.anthropic.com/en/docs/agents/claude-code/skills) (via MCP) -- "Every skill needs a SKILL.md file with two parts: YAML frontmatter that tells Claude when to use the skill, and markdown content with instructions."

#### [good] Effective use of supporting files in cc-audit

- **Current**: The cc-audit skill uses an `agents/` directory with 5 specialist instruction files (instructions-specialist.md, components-specialist.md, automation-specialist.md, integration-specialist.md, adversarial-reviewer.md). The main SKILL.md references these files and instructs Claude to read them at specific phases.
- **Project relevance**: This is the correct pattern for complex skills -- keeping the main SKILL.md focused on orchestration while deferring detailed instructions to supporting files. It demonstrates progressive disclosure, keeping context costs down.
- **Source**: [Add supporting files](https://docs.anthropic.com/en/docs/agents/claude-code/skills#add-supporting-files) (via MCP) -- "Skills can include multiple files in their directory. This keeps SKILL.md focused on the essentials while letting Claude access detailed reference material only when needed."

#### [improve] Sub-agent files live outside the standard discovery path

- **Current**: The cc-audit skill has 5 agent instruction files in `cc-audit/agents/`, but there is no `.claude/agents/` directory. These files are read manually by the skill during execution rather than being discoverable as proper Claude Code sub-agents. They function as reference documents, not as independently invocable sub-agents.
- **Recommendation**: This is acceptable for the current design (the skill orchestrates which agent file to read and when). However, if any of these specialist roles would be useful outside the cc-audit skill -- for example, running the adversarial reviewer independently -- consider promoting them to `.claude/agents/` with proper sub-agent frontmatter (`name`, `description`, `tools`, `model`).
- **Project relevance**: The cc-audit agents are tightly coupled to the cc-audit workflow, so keeping them as supporting files is the right call for now. The suggestion only applies if reuse becomes valuable.
- **Source**: [Create custom subagents](https://docs.anthropic.com/en/docs/agents/claude-code/sub-agents) (via MCP) -- "Subagent files use YAML frontmatter for configuration, followed by the system prompt in Markdown."

### Automation (Hooks + Permissions + Settings)

#### [fix] Stale permission rules in settings.local.json

- **Current**: `.claude/settings.local.json` contains 4 permission allow rules that reference paths under `/Users/giovannicordova/Documents/02_projects/minimal-framework/` -- a directory that either doesn't exist or has been renamed to `skills-gc`. These rules permit `rm -rf` and `ln -s` operations on the old path.
- **Recommendation**: Update the paths in `settings.local.json` to reflect the current project location, or remove the rules entirely if the symlink operations are no longer needed. Stale allow rules that reference non-existent paths are harmless but misleading -- they suggest active permissions that don't actually apply to anything.
- **Project relevance**: This project was apparently renamed or moved from `minimal-framework`. The permissions are leftover artefacts that could confuse anyone reviewing the configuration.
- **Source**: [Configure permissions](https://docs.anthropic.com/en/docs/agents/claude-code/permissions) (via MCP) -- "Allow rules let Claude Code use the specified tool without manual approval."

#### [improve] No project-level settings.json

- **Current**: The project has only `.claude/settings.local.json` (personal, not committed) and no `.claude/settings.json` (shared, committable). This means no shared configuration exists for anyone who clones this repository.
- **Recommendation**: Create `.claude/settings.json` with minimal shared configuration. For a skill library, this could include permission rules that protect skill files from accidental deletion, or simply serve as a placeholder that acknowledges Claude Code is used on this project. Given that the checkpoint skill itself recommends creating a SessionStart hook, consider adding that hook to the shared settings so it works for anyone using the project.
- **Project relevance**: This is a Claude Code skill library that others may clone and use. Shared settings ensure consistent behaviour across contributors and demonstrate how project-level settings work -- which is on-brand for a project teaching Claude Code best practices.
- **Source**: [Claude Code settings](https://docs.anthropic.com/en/docs/agents/claude-code/settings) (via MCP) -- "Project scope settings live in .claude/settings.json and affect all collaborators on this repository."

### Integration (MCP + Features)

#### [improve] Feature mix could be more self-demonstrating

- **Current**: This project uses 2 of 9 Claude Code features (Skills, partial Sub-agents). It lacks CLAUDE.md, Rules, Hooks, shared Permissions, shared Settings, and MCP configuration. For a pure markdown project with no external dependencies, most absences are justified -- there is no database to connect via MCP, no deployment to automate via hooks.
- **Recommendation**: As a skill library that teaches others how to use Claude Code, this project has an opportunity to demonstrate more features by using them itself. A CLAUDE.md, a scoped rule for SKILL.md files, and a shared settings.json would add minimal complexity while making the project a working reference for the features it documents. This isn't about feature completeness for its own sake -- it's about practising what the project teaches.
- **Project relevance**: Users who clone this repo to study skill construction will also see how CLAUDE.md, rules, and settings work in practice. The project becomes a teaching tool beyond just the skills it contains.
- **Source**: [Extend Claude Code](https://docs.anthropic.com/en/docs/agents/claude-code/features-overview) (via MCP) -- "CLAUDE.md for project conventions. Add other extensions as you need them."

## Priority Actions

| # | Type | What to do | Why it matters |
|---|------|-----------|----------------|
| 1 | fix | Create a `CLAUDE.md` at the project root with project overview, directory conventions, skill writing standards, and install instructions | Every session currently starts blind. This is the single highest-impact change for a Claude Code skill library. |
| 2 | fix | Update or remove stale paths in `.claude/settings.local.json` that reference `minimal-framework` | Eliminates confusing artefacts from a previous project name and ensures permissions reflect reality. |
| 3 | improve | Create `.claude/rules/skill-conventions.md` scoped to `**/SKILL.md` with writing standards for skill files | Ensures consistent quality across all 6 skills without repeating instructions every session. |
| 4 | improve | Create `.claude/settings.json` with shared project configuration | Makes Claude Code configuration portable for anyone cloning the repo. |
| 5 | improve | Consider promoting reusable agent instruction patterns to `.claude/agents/` with proper sub-agent frontmatter | Only if specialist roles (e.g., adversarial reviewer) become useful outside their parent skill. |

## Next Steps

To implement these recommendations:
1. Start a new Claude Code session
2. Enter Plan mode (Shift+Tab or /plan)
3. Tell Claude: "Read AUDIT-REPORT.md and create an implementation plan for the priority actions"
4. Review the plan, then execute
