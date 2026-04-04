# Claude Code Audit Report

> Audited: 2026-04-04 | Mode: MCP
> Project: skills-gc | Goal: Collection of 6 custom Claude Code skills (checkpoint, verify, plan-challenger, perspective, cc-audit, website-audit) -- audit the repo's own Claude Code configuration for effective skill development and testing.

## Current State

| Area | What it is | Status | Findings |
|------|-----------|--------|----------|
| CLAUDE.md | Your project's instructions to Claude | fix | 1 |
| Rules | Targeted instructions scoped to specific files | improve | 1 |
| Skills | Reusable workflows Claude can invoke | good | 1 |
| Sub-agents | Isolated Claude sessions for specific tasks | good | 1 |
| Hooks | Automated actions before/after Claude acts | improve | 1 |
| Permissions | What Claude can do without asking | fix | 1 |
| Settings | Project-level Claude Code configuration | improve | 1 |
| MCP | Connections to external tools and services | good | 1 |
| Features | Overall use of available Claude Code features | improve | 1 |

## Findings

### Instructions (CLAUDE.md + Rules)

#### [fix] No CLAUDE.md file exists

- **Current**: The project has no CLAUDE.md at the root, at `.claude/CLAUDE.md`, or in any subdirectory. Claude starts every session with zero context about what this project is, how its skills are structured, or what conventions to follow.
- **Recommendation**: Create a CLAUDE.md at the project root covering: what the project is (a collection of Claude Code skills), skill directory structure conventions (SKILL.md + evals/ + optional references/, agents/, scripts/), how to test skills (eval format and process), naming conventions (kebab-case directories, SKILL.md as entry point), and the symlink installation pattern. Run `/init` to generate a starting point, then refine. Keep it under 200 lines.
- **Project relevance**: This is a skills development repo. Every time Claude works on a skill here, it must re-discover the project structure, naming conventions, and testing approach. A CLAUDE.md eliminates that repeated overhead -- especially important because the project has 6 skills with a consistent pattern that Claude should understand immediately.
- **Source**: [CLAUDE.md files](https://docs.anthropic.com/en/docs/agents/claude-code/memory#claudemd-files) (via MCP)

#### [improve] No rules directory for skill-scoped conventions

- **Current**: No `.claude/rules/` directory exists. All skills follow the same directory pattern (SKILL.md, evals/, optional references/ and agents/) but this convention isn't documented anywhere Claude would see it.
- **Recommendation**: Create `.claude/rules/` with at least one path-scoped rule for `**/SKILL.md` files. This rule could specify: frontmatter requirements (name and description are mandatory), body length limits (under 500 lines), and that trigger phrases belong in the description. A second rule for `**/evals/*.json` could specify the eval file format.
- **Project relevance**: With 6 skills sharing the same structure, path-scoped rules would enforce consistency automatically whenever Claude edits any SKILL.md, without loading those conventions into every session via CLAUDE.md.
- **Source**: [Organize rules with .claude/rules/](https://docs.anthropic.com/en/docs/agents/claude-code/memory#organize-rules-with-clauderules) (via MCP)

### Components (Skills + Sub-agents)

#### [good] Skills are well-crafted with proper frontmatter and rich descriptions

- **Current**: All 6 SKILL.md files have proper YAML frontmatter with `name` and `description`. Descriptions include specific trigger phrases (e.g., checkpoint triggers on "checkpoint", "end of session", "save session", "wrap up"). Body lengths are within the 500-line guideline. Two skills (perspective, website-audit) use advanced features like `context: fork`, `disable-model-invocation: true`, and `allowed-tools`. The cc-audit skill uses a multi-specialist architecture with separate instruction files in `agents/`. The checkpoint skill even includes a hook installation step for session continuity.
- **Project relevance**: This is a project that develops skills -- the skills themselves being well-structured demonstrates the author understands the skill system well. The variety of patterns used (simple skills, forked context, sub-agent instructions, MCP tool references) makes this a good reference collection.
- **Source**: [Extend Claude with skills](https://docs.anthropic.com/en/docs/agents/claude-code/skills) (via MCP)

#### [good] Agent instruction files in cc-audit are appropriately structured

- **Current**: The `cc-audit/agents/` directory contains 5 markdown instruction files (instructions-specialist, components-specialist, automation-specialist, integration-specialist, adversarial-reviewer). These are read sequentially by the cc-audit skill during execution. They are not formal sub-agent definitions (no frontmatter with `name`/`description`/`tools`/`model` fields) but rather specialist instruction files the skill reads as reference material.
- **Project relevance**: This pattern is correct for the cc-audit skill's workflow: the specialists run sequentially in the main conversation, sharing context. Formal sub-agents would lose access to the documentation fetched earlier in the session. The current design keeps everything in one context window, which is the right choice for a sequential audit workflow.
- **Source**: [Create custom subagents](https://docs.anthropic.com/en/docs/agents/claude-code/sub-agents) (via MCP)

### Automation (Hooks + Permissions + Settings)

#### [improve] No hooks configured, missing a session continuity opportunity

- **Current**: No hooks are configured in any settings file. The checkpoint skill manually installs a `SessionStart` hook in target projects, but the skills-gc project itself has no hooks.
- **Recommendation**: Add a `SessionStart` hook to `.claude/settings.json` that prints the latest checkpoint log (if any exist in `logs/`). The checkpoint skill already defines this exact hook for target projects -- the skills-gc repo should eat its own cooking. This gives Claude immediate context when resuming skill development work.
- **Project relevance**: Skill development is iterative -- sessions often pick up where the last one left off. A SessionStart hook loading the latest checkpoint would provide continuity, especially since there is no CLAUDE.md to anchor context.
- **Source**: [Automate workflows with hooks](https://docs.anthropic.com/en/docs/agents/claude-code/hooks-guide#re-inject-context-after-compaction) (via MCP)

#### [fix] Permissions reference a stale project path

- **Current**: `.claude/settings.local.json` contains 4 permission rules allowing symlink commands, but they reference `minimal-framework` as the source path: `Bash(ln -s /Users/giovannicordova/Documents/02_projects/minimal-framework/checkpoint ...)`. The project has been renamed to `skills-gc`. These rules will never match actual commands and serve no purpose.
- **Recommendation**: Update the paths in `settings.local.json` to reference the current project location (`skills-gc` instead of `minimal-framework`). Also consider adding allow rules for the other 4 skills (perspective, plan-challenger, cc-audit, website-audit), not just checkpoint and verify.
- **Project relevance**: The whole purpose of these permission rules is to allow quick symlink installation of skills. With stale paths, the user gets prompted for permission every time, defeating the purpose.
- **Source**: [Configure permissions](https://docs.anthropic.com/en/docs/agents/claude-code/permissions#permission-rule-syntax) (via MCP)

#### [improve] No project-level settings.json

- **Current**: Only `.claude/settings.local.json` exists (with stale permission rules). There is no `.claude/settings.json` for shared project settings.
- **Recommendation**: Create `.claude/settings.json` with at minimum: permission rules that the team can share (allow rules for common operations like running evals, symlinking skills), and any hooks the project needs. Since `settings.local.json` is gitignored and `settings.json` is committable, shared conventions belong in the latter.
- **Project relevance**: If other people contribute skills to this repo, they would benefit from shared settings. Even as a solo project, having a committed settings file means Claude Code behaves consistently across machines and fresh clones.
- **Source**: [Claude Code settings](https://docs.anthropic.com/en/docs/agents/claude-code/settings) (via MCP)

### Integration (MCP + Features)

#### [good] MCP configuration is appropriately absent at project level

- **Current**: No `.mcp.json` or project-level MCP configuration exists. Individual skills reference user-level MCP tools (Context7, Playwright, anthropic-docs) via their `allowed-tools` frontmatter, which is the correct pattern -- these are user-installed tools, not project dependencies.
- **Project relevance**: This project has no databases, cloud services, or APIs that would benefit from project-scoped MCP servers. The skills that need MCP tools (perspective uses Context7, website-audit uses Playwright, cc-audit uses anthropic-docs) correctly reference them as tools the user needs to have installed, documented in their respective SKILL.md files. Adding a project-level `.mcp.json` would force unnecessary tool installation on anyone cloning the repo.
- **Source**: [Connect Claude Code to tools via MCP](https://docs.anthropic.com/en/docs/agents/claude-code/mcp#mcp-installation-scopes) (via MCP)

#### [improve] Feature selection gap -- project uses only 1 of 9 Claude Code features

- **Current**: The project extensively uses Skills (the core deliverable) but does not use CLAUDE.md, Rules, formal Sub-agents, Hooks, Settings, MCP, or Plugins. This means Claude works on skill development without persistent project context, conventions, or automation.
- **Recommendation**: At minimum, add CLAUDE.md (project context) and `.claude/settings.json` (permissions and hooks). Optionally add a `.claude/rules/skill-conventions.md` scoped to `**/SKILL.md` files. These three additions would cover the highest-impact gaps without over-engineering.
- **Project relevance**: A skills development repo benefits disproportionately from its own Claude Code setup being strong. When Claude is helping write or improve skills, it should have persistent context about skill structure conventions, eval format, and the project's goals. The current setup means every session starts from scratch.
- **Source**: [Extend Claude Code](https://docs.anthropic.com/en/docs/agents/claude-code/features-overview#match-features-to-your-goal) (via MCP)

## Priority Actions

| # | Type | What to do | Why it matters |
|---|------|-----------|----------------|
| 1 | fix | Create `CLAUDE.md` at project root with project description, skill structure conventions, eval format, and symlink installation instructions | Every session starts blind without it -- Claude must rediscover the project structure each time |
| 2 | fix | Update stale paths in `.claude/settings.local.json` from `minimal-framework` to `skills-gc` | Permission rules are non-functional; symlink commands always trigger approval prompts |
| 3 | improve | Create `.claude/settings.json` with shared permissions and a SessionStart hook loading the latest checkpoint | Provides session continuity and shared config for consistent Claude Code behaviour |
| 4 | improve | Add `.claude/rules/skill-conventions.md` scoped to `**/SKILL.md` with frontmatter and structure requirements | Enforces consistency across all 6 skills automatically when Claude edits them |
| 5 | improve | Review feature selection -- CLAUDE.md + settings + rules covers the highest-impact gaps | A skills repo benefits from strong Claude Code setup; currently uses only 1 of 9 features |

## Next Steps

To implement these recommendations:
1. Start a new Claude Code session
2. Enter Plan mode (Shift+Tab or /plan)
3. Tell Claude: "Read AUDIT-REPORT.md and create an implementation plan for the priority actions"
4. Review the plan, then execute
