# Claude Code Audit Report

> Audited: 2026-04-04 | Mode: MCP
> Project: skills-gc | Goal: Audit a Claude Code skill library across all 9 areas, with particular attention to hooks and MCP configuration

## Current State

| Area | What it is | Status | Findings |
|------|-----------|--------|----------|
| CLAUDE.md | Your project's instructions to Claude | fix | 1 |
| Rules | Targeted instructions scoped to specific files | good | 0 |
| Skills | Reusable workflows Claude can invoke | good | 2 |
| Sub-agents | Isolated Claude sessions for specific tasks | good | 0 |
| Hooks | Automated actions before/after Claude acts | good | 0 |
| Permissions | What Claude can do without asking | fix | 1 |
| Settings | Project-level Claude Code configuration | improve | 1 |
| MCP | Connections to external tools and services | good | 0 |
| Features | Overall use of available Claude Code features | improve | 1 |

## Findings

### Instructions (CLAUDE.md + Rules)

#### [fix] No CLAUDE.md file exists

- **Current**: The project has no CLAUDE.md at the root or in `.claude/`. Claude starts every session with no knowledge of what this project is, how the skills are structured, or how to develop and test them.
- **Recommendation**: Create a CLAUDE.md covering: (1) what this project is (a collection of 6 Claude Code skills), (2) the standard skill directory structure (SKILL.md + evals/ + optional supporting directories), (3) how skills are installed (symlinks to `~/.claude/skills/`), (4) conventions for writing skills (frontmatter requirements, description quality, body length under 500 lines), and (5) how to run evals. Keep it under 200 lines. Run `/init` to generate a starting point, then refine.
- **Project relevance**: This is a skill library. Every development session involves reading and writing SKILL.md files. Without a CLAUDE.md, Claude doesn't know the project's conventions, the expected skill structure, or that `evals/` directories contain test cases. This creates friction on every single session.
- **Source**: [How Claude remembers your project](https://docs.anthropic.com/en/docs/agents/claude-code/memory) (via MCP) -- "Every project using Claude Code benefits from a CLAUDE.md -- it's Claude's only persistent memory of the project across sessions."

### Components (Skills + Sub-agents)

#### [good] Skills are well-structured with proper frontmatter

- **Current**: All 6 skills (checkpoint, verify, plan-challenger, perspective, cc-audit, website-audit) have correct YAML frontmatter with `name` and `description` fields. Descriptions are detailed, include specific trigger phrases, and explain when to use the skill. For example, verify's description lists 6 trigger phrases and explicitly excludes misuse cases.
- **Project relevance**: This is a skill library -- the skills themselves are the product. Getting the frontmatter and descriptions right is the core quality standard, and this project meets it.
- **Source**: [Extend Claude with skills](https://docs.anthropic.com/en/docs/agents/claude-code/skills) (via MCP) -- "The description is the trigger mechanism. It determines when Claude decides to use the skill."

#### [good] Effective use of supporting files and context isolation

- **Current**: cc-audit uses an `agents/` directory with 5 specialist instruction files that the skill reads sequentially. website-audit uses `references/` (7 rule files), `scripts/` (4 executable scripts), and `modules/` (extraction logic + report template). perspective and website-audit use `context: fork` with explicit `allowed-tools` for safe, isolated execution.
- **Project relevance**: These patterns demonstrate the full range of skill architecture documented by Anthropic -- supporting files for progressive disclosure, scripts for deterministic automation, and forked context for isolation. The skills practise what the library preaches.
- **Source**: [Extend Claude with skills -- Add supporting files](https://docs.anthropic.com/en/docs/agents/claude-code/skills) (via MCP) -- "Skills can include multiple files in their directory. This keeps SKILL.md focused on the essentials while letting Claude access detailed reference material only when needed."

### Automation (Hooks + Permissions + Settings)

#### [fix] Stale permission paths in settings.local.json

- **Current**: `.claude/settings.local.json` contains 4 allow rules referencing `/Users/giovannicordova/Documents/02_projects/minimal-framework/checkpoint` and `/Users/giovannicordova/Documents/02_projects/minimal-framework/verify`. The project directory is `skills-gc`, not `minimal-framework`. These permissions will never match because the paths don't exist.
- **Recommendation**: Update the paths to reference the current project location, or remove these rules entirely if the symlinking workflow has changed. The current rules are:
  ```
  Bash(rm -rf /Users/giovannicordova/.claude/skills/checkpoint)
  Bash(ln -s .../minimal-framework/checkpoint ...)
  Bash(rm -rf /Users/giovannicordova/.claude/skills/verify)
  Bash(ln -s .../minimal-framework/verify ...)
  ```
  These should point to `.../skills-gc/checkpoint` and `.../skills-gc/verify` if still needed.
- **Project relevance**: The symlink installation workflow is how users install these skills. Broken permission rules mean Claude will prompt for permission every time instead of auto-allowing, creating unnecessary friction during development.
- **Source**: [Configure permissions](https://docs.anthropic.com/en/docs/agents/claude-code/permissions) (via MCP) -- "Allow rules let Claude Code use the specified tool without manual approval."

#### [improve] No project-level settings.json for team configuration

- **Current**: The project has `.claude/settings.local.json` (gitignored) but no `.claude/settings.json` (shareable). If another developer clones this repo, they get no project-level Claude Code configuration at all.
- **Recommendation**: Create `.claude/settings.json` with settings that apply to anyone developing skills in this repo. At minimum, this could include permission rules for common skill development commands (running evals, symlinking skills) and any project-wide conventions.
- **Project relevance**: The README instructs users to symlink skills. A shared settings.json could pre-allow those symlink commands for the correct paths, reducing setup friction for anyone cloning the repo.
- **Source**: [Claude Code settings](https://docs.anthropic.com/en/docs/agents/claude-code/settings) (via MCP) -- "Project scope: `.claude/` in repository. All collaborators on this repository. Yes (committed to git)."

### Integration (MCP + Features)

#### [improve] Feature coverage appropriate but CLAUDE.md gap undermines the whole setup

- **Current**: The project uses Skills (6, well-built) as its core feature. It correctly does not use project-level hooks, MCP, rules, or sub-agents -- none are needed for a markdown skill library. However, the one missing feature that would benefit this project most is CLAUDE.md, which is the simplest and highest-impact Claude Code feature to adopt.
- **Recommendation**: Start with CLAUDE.md (see the fix finding above). After that, consider adding one path-scoped rule for `**/SKILL.md` files with skill writing conventions -- this would load automatically whenever Claude edits a skill.
- **Project relevance**: The features documentation explicitly recommends CLAUDE.md as the starting point for every project: "New to Claude Code? Start with CLAUDE.md for project conventions." This project skipped step one while building advanced features (skills with sub-agent patterns, forked contexts, evaluation frameworks).
- **Source**: [Extend Claude Code -- Match features to your goal](https://docs.anthropic.com/en/docs/agents/claude-code/features-overview) (via MCP) -- "New to Claude Code? Start with CLAUDE.md for project conventions. Add other extensions as you need them."

## Priority Actions

| # | Type | What to do | Why it matters |
|---|------|-----------|----------------|
| 1 | fix | Create a CLAUDE.md at the project root covering project identity, skill structure conventions, installation workflow, and eval instructions | Every development session starts blind without it. Claude doesn't know this is a skill library or how skills should be structured. This is the single highest-impact improvement. |
| 2 | fix | Update `.claude/settings.local.json` to replace `minimal-framework` paths with `skills-gc` | Stale paths mean permission rules never match, causing unnecessary prompts during skill installation. |
| 3 | improve | Create `.claude/settings.json` with shareable project settings | Anyone cloning this repo gets zero Claude Code configuration. A shared settings file reduces setup friction for contributors. |
| 4 | improve | Consider a path-scoped rule at `.claude/rules/skill-writing.md` targeting `**/SKILL.md` | Would automatically load skill-writing conventions whenever Claude edits a skill file, enforcing consistency without bloating CLAUDE.md. |

## Next Steps

To implement these recommendations:
1. Start a new Claude Code session
2. Enter Plan mode (Shift+Tab or /plan)
3. Tell Claude: "Read AUDIT-REPORT.md and create an implementation plan for the priority actions"
4. Review the plan, then execute
