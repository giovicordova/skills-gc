# Claude Code Audit Report

> Audited: 2026-04-04 | Mode: MCP (anthropic-docs)
> Project: skills-gc | Goal: Collection of custom Claude Code skills distributed via symlinks

## Current State

| Area | What it is | Status | Findings |
|------|-----------|--------|----------|
| CLAUDE.md | Your project's instructions to Claude | fix | 2 |
| Rules | Targeted instructions scoped to specific files | improve | 1 |
| Skills | Reusable workflows Claude can invoke | good | 3 |
| Sub-agents | Isolated Claude sessions for specific tasks | improve | 2 |
| Hooks | Automated actions before/after Claude acts | improve | 2 |
| Permissions | What Claude can do without asking | improve | 1 |
| Settings | Project-level Claude Code configuration | improve | 1 |
| MCP | Connections to external tools and services | good | 1 |
| Features | Overall use of available Claude Code features | improve | 2 |

## Findings

### Instructions (CLAUDE.md + Rules)

#### [fix] No project-level CLAUDE.md exists

- **Current**: The `skills-gc` repository has no `CLAUDE.md` at the project root, no `.claude/CLAUDE.md`, and no `CLAUDE.local.md`. The only CLAUDE.md loaded when working in this repo is the user-level `~/.claude/CLAUDE.md`, which contains personal preferences (style, honesty, research rules) but nothing about this project.
- **Recommendation**: Create a `CLAUDE.md` at the project root. For a skills collection, it should include: what this repo is (a collection of Claude Code skills), the directory convention (each skill is a top-level directory with `SKILL.md` + `evals/`), how skills are installed (symlink to `~/.claude/skills/`), and how evals work. This is the single highest-impact change because Claude starts every session without knowing what this project is or how it is structured.
- **Project relevance**: Without a CLAUDE.md, every new session in this repo forces the user to re-explain context. For a project that is itself a collection of Claude Code skills, this is particularly ironic -- the repo teaches Claude how to do things, but does not teach Claude about the repo itself.
- **Source**: [CLAUDE.md files](/docs/en/memory) -- "Every project using Claude Code benefits from a CLAUDE.md -- it's Claude's only persistent memory of the project across sessions." (via MCP)

#### [fix] User-level CLAUDE.md lacks project-switching awareness

- **Current**: `~/.claude/CLAUDE.md` (32 lines) contains personal preferences -- style, honesty, research, technical language. This is well-structured and concise. However, it contains no pointers to project-specific workflows or conventions for the skills-gc repo.
- **Recommendation**: The user-level CLAUDE.md is correctly scoped for personal preferences. The fix is to create the project-level CLAUDE.md (above), not to bloat the user file. The user-level file is well within the recommended ~200 line limit and covers the right content for its scope.
- **Project relevance**: The user-level CLAUDE.md is well-crafted for a non-developer user -- it prioritises plain language, web search before building, and honesty. These are good conventions. The gap is at the project level, not the user level.
- **Source**: [Choose where to put CLAUDE.md files](/docs/en/memory) -- "Project root: team-shared instructions for the project... User instructions: personal preferences for all projects." (via MCP)

#### [improve] No `.claude/rules/` directory

- **Current**: The project has no `.claude/rules/` directory. All instructions would need to go in CLAUDE.md.
- **Recommendation**: For a skills collection, path-scoped rules could be valuable. For example, a rule scoped to `*/SKILL.md` files could enforce skill authoring conventions (frontmatter requirements, line limits, description quality). A rule scoped to `*/evals/*.json` could enforce eval structure. This would provide guardrails when editing skills without loading those rules in every session context.
- **Project relevance**: This project has 6 skills with different structures. A shared rule for SKILL.md authoring conventions would enforce consistency without requiring each skill to document the same standards. The `cc-audit/references/skills-guide.md` already documents skill quality criteria -- some of those criteria could become enforced rules.
- **Source**: [Organize rules with .claude/rules/](/docs/en/memory) -- "Rules can also be scoped to specific file paths, so they only load into context when Claude works with matching files, reducing noise and saving context space." (via MCP)

### Components (Skills + Sub-agents)

#### [good] Skills are well-structured with strong SKILL.md files

- **Current**: All 6 skills follow a consistent directory structure: `SKILL.md` at the root, `evals/` for test cases, and optional `references/`, `scripts/`, `modules/`, and `agents/` directories for supporting material. Every SKILL.md has proper YAML frontmatter with `name` and `description` fields. Descriptions are detailed, include specific trigger phrases, and explain both what the skill does and when to use it. Line counts are healthy: checkpoint (132), verify (70), plan-challenger (98), perspective (219), website-audit (229), cc-audit (261) -- all under 500 lines.
- **Project relevance**: This is the core competency of the project and it shows. The skill descriptions in particular are exemplary -- they include multiple trigger phrases, clarify edge cases (e.g., verify's description explicitly excludes "reviewing other people's code"), and use assertive language to ensure Claude triggers them.
- **Source**: [Extend Claude with skills](/docs/en/skills) -- "The description helps Claude decide when to apply the skill... Only description is recommended so Claude knows when to use the skill." (via MCP)

#### [good] Progressive disclosure and supporting files

- **Current**: Larger skills use progressive disclosure well. The `cc-audit` skill keeps its SKILL.md focused on the audit workflow and stores specialist evaluation criteria in `agents/*.md` and reference material in `references/skills-guide.md`. The `website-audit` skill bundles executable scripts (`scripts/score.py`, `scripts/lighthouse.sh`, etc.) and extraction modules (`modules/extraction.js`). The `perspective` skill uses Context7 MCP for live documentation lookup.
- **Project relevance**: This is the pattern Anthropic recommends: keep SKILL.md under 500 lines and move detailed content to supporting files. The fact that these skills are themselves teaching material makes their structure doubly important -- they are both functional and exemplary.
- **Source**: [Add supporting files](/docs/en/skills) -- "Keep SKILL.md under 500 lines. Move detailed reference material to separate files." (via MCP)

#### [good] Two skills use advanced frontmatter correctly

- **Current**: The `perspective` and `website-audit` skills use `disable-model-invocation: true`, `context: fork`, and `allowed-tools` in their frontmatter. `perspective` restricts tools to Read, Write, Edit, Glob, Grep, Bash, WebSearch, WebFetch, and Context7 MCP tools. `website-audit` restricts to Read, Bash, Write, Glob, Grep, plus Playwright MCP tools and defines named sub-agents (lighthouse-runner, perplexity-checker).
- **Project relevance**: These are the two most complex skills in the collection, and the frontmatter correctly isolates them in forked contexts with limited tool access. The `disable-model-invocation: true` flag prevents Claude from auto-triggering what are essentially heavyweight audit workflows -- the user must invoke them explicitly. This matches the documented best practice.
- **Source**: [Control who invokes a skill](/docs/en/skills) -- "disable-model-invocation: true prevents Claude from running it automatically... Use this for workflows with side effects or that you want to control timing." (via MCP)

#### [improve] cc-audit skill defines agent instruction files but not as proper sub-agents

- **Current**: The `cc-audit` skill stores 5 specialist instruction files in `cc-audit/agents/` (instructions-specialist.md, components-specialist.md, automation-specialist.md, integration-specialist.md, adversarial-reviewer.md). However, these are not proper Claude Code sub-agent definitions -- they lack YAML frontmatter with `name`, `description`, `tools`, and `model` fields. The cc-audit SKILL.md instructs Claude to "read the instruction file... and follow its evaluation criteria" sequentially, rather than spawning them as parallel sub-agents.
- **Recommendation**: These specialists are ideal candidates for proper sub-agent definitions with frontmatter. Each specialist is independent (instructions, components, automation, integration) and could run in parallel, with only the adversarial-reviewer needing their combined output. Converting them would allow parallel execution and context isolation. Add frontmatter to each file:
  ```yaml
  ---
  name: instructions-specialist
  description: Audits CLAUDE.md and Rules configuration
  tools: Read, Glob, Grep
  model: haiku
  ---
  ```
- **Project relevance**: The cc-audit skill explicitly documents 4 independent specialist audits (steps 4.1-4.4). Running them sequentially in the main context wastes time and fills the context window. Parallel sub-agents would reduce audit time and keep verbose analysis isolated, returning only findings to the main conversation.
- **Source**: [Create custom subagents](/docs/en/sub-agents) -- "Each subagent runs in its own context window with a custom system prompt, specific tool access, and independent permissions... Subagents help you preserve context by keeping exploration and implementation out of your main conversation." (via MCP)

#### [improve] Skills are not installed in the project's own `.claude/skills/`

- **Current**: Skills live at the project root as top-level directories (`checkpoint/`, `verify/`, `plan-challenger/`, etc.), not inside `.claude/skills/`. The README instructs users to install via symlinks to `~/.claude/skills/`. The project's `.claude/settings.local.json` contains permission rules for symlink operations referencing a different path (`minimal-framework`, not `skills-gc`), suggesting a rename occurred.
- **Recommendation**: This is a design choice, not a bug -- the skills are meant to be installed globally via symlinks. However, adding a `.claude/skills/` directory with symlinks back to the top-level skill directories would allow Claude Code to discover the skills when working in this repo. Currently, if you open Claude Code in `skills-gc/` without having separately symlinked everything to `~/.claude/skills/`, Claude has no access to the skills as invocable commands.
- **Project relevance**: When developing or testing skills in this repo, it would be useful to have them discoverable as slash commands. The `settings.local.json` already contains symlink commands -- this suggests the user has been manually managing installation.
- **Source**: [Where skills live](/docs/en/skills) -- "Personal: ~/.claude/skills/<skill-name>/SKILL.md... Project: .claude/skills/<skill-name>/SKILL.md." (via MCP)

### Automation (Hooks + Permissions + Settings)

#### [improve] No hooks configured despite the checkpoint skill defining one

- **Current**: The project has no `.claude/settings.json` (only `.claude/settings.local.json` with permission rules). The `checkpoint` skill instructs Claude to create a `SessionStart` hook that loads the latest checkpoint log on session start. But this hook is created by the skill at runtime in the target project, not pre-configured in the skills-gc repo itself.
- **Recommendation**: Create a `.claude/settings.json` with hooks useful for skill development. Candidates:
  - `SessionStart` hook to load the latest checkpoint log (as the checkpoint skill itself prescribes)
  - `PostToolUse` hook on `Edit|Write` with a matcher for `*/SKILL.md` to validate frontmatter after edits
  - `Notification` hook for desktop notifications during long eval runs
- **Project relevance**: This is a repo where you develop and test skills. A SessionStart hook loading the last checkpoint would demonstrate eating your own cooking -- using the checkpoint skill's output to maintain session continuity in this very project.
- **Source**: [Automate workflows with hooks](/docs/en/hooks-guide) -- "Hooks are user-defined shell commands that execute at specific points in Claude Code's lifecycle. They provide deterministic control over Claude Code's behavior." (via MCP)

#### [improve] No shared project settings file

- **Current**: The only settings file is `.claude/settings.local.json`, which contains 4 permission allow rules for specific Bash commands (removing and symlinking skill directories). There is no `.claude/settings.json` (the shared, committable project settings file).
- **Recommendation**: Create `.claude/settings.json` for settings that should be shared via version control. Move any non-personal settings there. The current `settings.local.json` content is personal (references specific absolute paths on this machine), so it correctly belongs in local. But the project needs a shared settings file for hooks, any project-wide permission rules, and feature flags.
- **Project relevance**: Since this is a skills collection that others could clone and use, a shared `settings.json` would provide sensible defaults for anyone working on the skills.
- **Source**: [Settings files](/docs/en/settings) -- "Project: .claude/ in repository... All collaborators on this repository... Yes (committed to git)." (via MCP)

#### [improve] Permission rules reference an outdated project path

- **Current**: `.claude/settings.local.json` contains 4 permission allow rules that reference `/Users/giovannicordova/Documents/02_projects/minimal-framework/` -- both for `rm -rf` and `ln -s` operations on `checkpoint` and `verify` skills. The project has been renamed to `skills-gc` and now contains 6 skills (not just 2).
- **Recommendation**: Update the paths to reference the current project location and add rules for all 6 skills (checkpoint, verify, plan-challenger, perspective, website-audit, cc-audit). The stale paths mean the existing permission rules will not match any actual commands Claude would run.
- **Project relevance**: These rules exist to speed up skill installation. With stale paths, they serve no purpose -- Claude will still prompt for permission every time.
- **Source**: [Configure permissions](/docs/en/permissions) -- "Allow rules let Claude Code use the specified tool without manual approval." (via MCP)

### Integration (MCP + Features)

#### [good] Skills leverage MCP tools effectively

- **Current**: Two skills explicitly declare MCP tool dependencies in their `allowed-tools` frontmatter. The `perspective` skill uses Context7 MCP (`mcp__plugin_context7_context7__resolve-library-id` and `mcp__plugin_context7_context7__query-docs`) for live documentation lookup. The `website-audit` skill uses Playwright MCP tools for browser-based crawling. The `cc-audit` skill uses Anthropic Docs MCP for fetching current documentation.
- **Project relevance**: This is a strong pattern. Rather than relying on stale training data, these skills fetch live documentation and perform real browser interactions. The `cc-audit` skill even has a fallback chain (MCP > Playwright > stop) for documentation access.
- **Source**: [Connect Claude Code to tools via MCP](/docs/en/mcp) -- MCP servers provide tools and data access to Claude Code. (via MCP)

#### [improve] No project-level `.mcp.json` documents required MCP servers

- **Current**: Skills reference MCP tools (Context7, Playwright, Anthropic Docs) but there is no `.mcp.json` or MCP configuration in any project settings file. Users must have these MCP servers configured at the user level (`~/.claude/settings.json`) for the skills to function.
- **Recommendation**: Add a `.mcp.json` at the project root (or document MCP requirements in a project CLAUDE.md) listing the MCP servers these skills depend on. This is especially important for skills like `cc-audit` which will fail outright without the Anthropic Docs MCP server -- it even tells the user how to install it, but only after failing to find it.
- **Project relevance**: The skills are designed to be installed via symlinks into other projects. The MCP dependencies travel with the SKILL.md but the MCP server configurations do not. A new user cloning this repo would need to discover and install each MCP server independently.
- **Source**: [Connect Claude Code to tools via MCP](/docs/en/mcp) -- "Adding MCP servers... claude mcp add-json my-server" for project-level MCP configuration. (via MCP)

#### [improve] Eval infrastructure exists but is not automated

- **Current**: Every skill has an `evals/` directory with `evals.json` files containing test cases. These are well-structured with `prompt`, `expected_output`, and `expectations` fields (e.g., checkpoint has 3 evals, plan-challenger has detailed eval scenarios). There are also `workspace/` directories with iteration results comparing `with_skill` and `without_skill` runs. However, there is no automation -- no hooks, scripts, or CI configuration to run evals automatically.
- **Recommendation**: This is a clear candidate for automation. Options:
  1. A `run-evals` skill that orchestrates eval execution across all skills
  2. A hook on `PostToolUse` (matching `Edit|Write` on `*/SKILL.md`) that prompts for eval re-run after skill edits
  3. A simple shell script invoked via `claude -p` for CI integration
- **Project relevance**: The eval infrastructure is already the project's quality assurance mechanism. Automating it would reduce the manual effort of running comparisons after every skill edit. The `website-audit-workspace` and `verify/workspace` directories show this is already a repeated workflow.
- **Source**: [Best Practices for Claude Code](/docs/en/best-practices) -- "Use claude -p 'prompt' in CI, pre-commit hooks, or scripts. Add --output-format stream-json for streaming JSON output." (via MCP)

## Priority Actions

| # | Type | What to do | Why it matters |
|---|------|-----------|----------------|
| 1 | fix | Create `CLAUDE.md` at project root with project description, directory conventions, skill structure, installation instructions, and eval workflow | Every session currently starts with zero project context. This is the highest-leverage single change. |
| 2 | fix | Update `.claude/settings.local.json` to use current project path (`skills-gc`) and cover all 6 skills | Current permission rules reference a renamed project and only cover 2 of 6 skills -- they do nothing. |
| 3 | improve | Convert cc-audit specialist files to proper sub-agent definitions with frontmatter for parallel execution | The 4 independent specialists are ideal for parallel sub-agents -- saves time and isolates context. |
| 4 | improve | Create `.claude/settings.json` with a `SessionStart` hook and project-wide settings | Enables session continuity and provides a shared configuration baseline for collaborators. |
| 5 | improve | Add `.claude/rules/skill-authoring.md` scoped to `*/SKILL.md` enforcing frontmatter and structure standards | Codifies the quality criteria from `cc-audit/references/skills-guide.md` as enforceable rules. |

## Next Steps

To implement these recommendations:
1. Start a new Claude Code session
2. Enter Plan mode (Shift+Tab or /plan)
3. Tell Claude: "Read cc-audit-workspace/iteration-1/basic-trigger/without_skill/outputs/AUDIT-REPORT.md and create an implementation plan for the priority actions"
4. Review the plan, then execute
