# Claude Code Audit Report

> Audited: 2026-04-04 | Mode: MCP
> Project: skills-gc | Goal: Audit a collection of Claude Code skills (checkpoint, verify, plan-challenger, perspective, cc-audit, website-audit) for correct configuration across all 9 areas, with particular focus on hooks and MCP.

## Current State

| Area | What it is | Status | Findings |
|------|-----------|--------|----------|
| CLAUDE.md | Your project's instructions to Claude | fix | 1 |
| Rules | Targeted instructions scoped to specific files | improve | 1 |
| Skills | Reusable workflows Claude can invoke | good | 2 |
| Sub-agents | Isolated Claude sessions for specific tasks | good | 1 |
| Hooks | Automated actions before/after Claude acts | improve | 2 |
| Permissions | What Claude can do without asking | fix | 1 |
| Settings | Project-level Claude Code configuration | improve | 1 |
| MCP | Connections to external tools and services | good | 1 |
| Features | Overall use of available Claude Code features | improve | 1 |

## Findings

### Instructions (CLAUDE.md + Rules)

#### [fix] No project CLAUDE.md exists

- **Current**: The project has no `CLAUDE.md` at the root or at `.claude/CLAUDE.md`. Claude starts every session with no persistent knowledge of what this project is, how the skills are structured, or how to work with them.
- **Recommendation**: Create a `CLAUDE.md` covering: what skills-gc is (a collection of Claude Code skills), the directory convention (each skill is a top-level folder with `SKILL.md`, optional `agents/`, `evals/`, `references/`), how skills are installed (symlinked into `~/.claude/skills/`), and that each skill is standalone markdown with no code dependencies. Keep it under 100 lines.
- **Project relevance**: This is a skills authoring project. Without a CLAUDE.md, every time you open a session to edit or create a skill, Claude has to rediscover the project structure, naming conventions, and quality standards. A CLAUDE.md eliminates that cold-start penalty entirely.
- **Source**: [How Claude remembers your project](https://docs.anthropic.com/en/docs/agents/claude-code/memory) (via MCP)

#### [improve] No .claude/rules/ directory for file-type-specific instructions

- **Current**: No `.claude/rules/` directory exists. All skills follow the same SKILL.md structure, but there are no file-scoped rules enforcing consistency.
- **Recommendation**: Add a `.claude/rules/` directory with a `skill-authoring.md` rule scoped to `**/SKILL.md` files. Include conventions like: frontmatter must have `name` and `description`, body should stay under 500 lines, use imperative instructions, and cite documentation sources when recommending features. This enforces quality every time Claude edits a skill file.
- **Project relevance**: You are actively building and iterating on skills. A rule scoped to `**/SKILL.md` would automatically load skill-authoring standards whenever Claude opens a SKILL.md file, without bloating the main CLAUDE.md.
- **Source**: [Organize rules with .claude/rules/](https://docs.anthropic.com/en/docs/agents/claude-code/memory#organize-rules-with-clauderules) (via MCP)

### Components (Skills + Sub-agents)

#### [good] Skills are well-structured with strong frontmatter

- **Current**: All 6 skills have proper YAML frontmatter with `name` and `description` fields. Descriptions are detailed and include explicit trigger phrases (e.g., checkpoint lists "save session", "wrap up", "end of session"). The `perspective` and `website-audit` skills appropriately use `disable-model-invocation: true` and `context: fork` for heavier workflows that should only run when explicitly invoked. Skills use `allowed-tools` to restrict tool access where appropriate.
- **Project relevance**: This is a skill authoring project -- the skills themselves are the product. Having them follow documented best practices is essential.
- **Source**: [Extend Claude with skills](https://docs.anthropic.com/en/docs/agents/claude-code/skills) (via MCP)

#### [good] Progressive disclosure pattern used effectively

- **Current**: The `cc-audit` skill uses a `references/` directory and an `agents/` directory to keep the main SKILL.md focused on workflow orchestration while offloading specialist knowledge to separate files. The main SKILL.md instructs Claude to read specialist files at the appropriate step rather than loading everything upfront.
- **Project relevance**: This pattern directly follows the documentation recommendation to keep SKILL.md under 500 lines and use supporting files for detailed reference material. It serves as a good template for future skills.
- **Source**: [Add supporting files](https://docs.anthropic.com/en/docs/agents/claude-code/skills#add-supporting-files) (via MCP)

#### [good] Sub-agents are well-scoped and purposeful

- **Current**: The cc-audit skill has 5 agent instruction files in `agents/`: 4 domain specialists (instructions, components, automation, integration) and 1 adversarial reviewer. Each has a clear, focused role with explicit evaluation criteria and expected output format. The agents are used sequentially within the skill's workflow, which is appropriate since each specialist's output feeds into the adversarial reviewer.
- **Project relevance**: These agent files serve as the "brain" of the audit skill. Their quality directly determines the audit's usefulness. They are self-contained and well-structured -- a good reference implementation for sub-agent design.
- **Source**: [Create custom subagents](https://docs.anthropic.com/en/docs/agents/claude-code/sub-agents) (via MCP)

### Automation (Hooks + Permissions + Settings)

#### [improve] No project-level hooks -- checkpoint skill sets one up manually

- **Current**: No `.claude/settings.json` exists at the project level, so there are no project-level hooks. The `checkpoint` skill contains instructions to manually set up a `SessionStart` hook that reads the latest checkpoint log. This means the hook only gets created after the first checkpoint run, and only if the user follows the setup steps.
- **Recommendation**: Create a `.claude/settings.json` with the checkpoint's `SessionStart` hook pre-configured. This way, the hook is ready from the moment the project is cloned -- no manual setup required. The checkpoint skill's one-time setup section can then reference this rather than creating it from scratch.
- **Project relevance**: Since checkpoint is one of your core skills and this is a skills development project where sessions often build on previous work, having the session-start hook ready out of the box reduces friction for anyone using this repo.
- **Source**: [Automate workflows with hooks](https://docs.anthropic.com/en/docs/agents/claude-code/hooks-guide) (via MCP)

#### [improve] User-level hooks exist but are not documented in the project

- **Current**: Your `~/.claude/settings.json` has hooks configured at the user level: `SessionStart` (run-hook.cmd, gsd-check-update), `PostToolUse` (frontend-quality-gate, gsd-context-monitor), and `Notification` (macOS desktop notification). These run across all projects, including skills-gc, but the project has no awareness of them.
- **Recommendation**: This is informational for the audit -- your user-level hooks are well-configured and follow documented patterns (correct event types, appropriate matchers like `Write|Edit` for the quality gate, proper use of `async: false` for session-start). The notification hook correctly uses the macOS `osascript` pattern from the documentation. No changes needed here, but be aware that hooks from plugins (GSD) also fire in this project.
- **Project relevance**: You asked specifically about hooks. Your user-level hooks are correctly configured. The gap is at the project level, not the user level.
- **Source**: [Configure hook location](https://docs.anthropic.com/en/docs/agents/claude-code/hooks-guide#configure-hook-location) (via MCP)

#### [fix] Permissions in settings.local.json reference a stale path

- **Current**: `.claude/settings.local.json` contains 4 permission rules allowing symlink operations (rm -rf and ln -s) for `checkpoint` and `verify` skills. All 4 rules reference `/Users/giovannicordova/Documents/02_projects/minimal-framework/` -- but the project has been renamed to `skills-gc`. These rules will never match and serve no purpose.
- **Recommendation**: Update the paths in `settings.local.json` to reference the current project path (`/Users/giovannicordova/Documents/02_projects/skills-gc/`), and add rules for all 6 skills (not just checkpoint and verify). Or remove these rules entirely if you no longer use this approach to install skills.
- **Project relevance**: Stale permission rules are not just dead code -- they suggest the symlink installation workflow hasn't been maintained as the project evolved. The README instructs users to symlink skills, but the permission rules enabling that workflow are broken.
- **Source**: [Configure permissions](https://docs.anthropic.com/en/docs/agents/claude-code/permissions) (via MCP)

#### [improve] No project-level settings.json

- **Current**: The project has no `.claude/settings.json` (only `settings.local.json` for personal permissions). All Claude Code configuration for this project comes from user-level settings.
- **Recommendation**: Create a `.claude/settings.json` with shared configuration: the checkpoint SessionStart hook (as noted above), and any project-level permission rules that should apply to all contributors (e.g., protecting the `evals/` directories from accidental modification during skill development). This file can be committed to git so anyone cloning the repo gets a working setup.
- **Project relevance**: As a skills collection meant to be shared (it has a README with install instructions and an MIT licence), having a project-level settings.json ensures contributors get a consistent Claude Code experience.
- **Source**: [Claude Code settings](https://docs.anthropic.com/en/docs/agents/claude-code/settings) (via MCP)

### Integration (MCP + Features)

#### [good] No project-level MCP is the right call

- **Current**: No `.mcp.json` exists. No MCP servers are configured at the project level. The project has no code dependencies, no databases, no cloud services, and no external APIs to connect to.
- **Project relevance**: This is a pure markdown/configuration project. MCP servers would add complexity with no benefit. Individual skills that need MCP (like cc-audit needing `anthropic-docs`, or perspective needing `context7`) correctly reference those tools in their `allowed-tools` frontmatter, relying on user-level MCP configuration. This is the right approach -- the skills declare what they need, the user provides it.
- **Source**: [Connect Claude Code to tools via MCP](https://docs.anthropic.com/en/docs/agents/claude-code/mcp) (via MCP)

#### [improve] Feature usage is strong for skills but missing the foundation layer

- **Current**: The project makes excellent use of the components layer (6 skills, sub-agents) and correctly opts out of MCP at the project level. However, it skips the foundation layer entirely: no CLAUDE.md, no rules, no project-level settings. This means Claude Code's "always-on" context system is empty -- Claude learns about this project only when a skill is invoked, not when a session starts.
- **Recommendation**: Add CLAUDE.md (covered above) and a project-level settings.json with the checkpoint hook. These two additions fill the foundation gap. Rules are a nice-to-have for later. The project does not need plugins, agent teams, or additional MCP servers.
- **Project relevance**: The documentation's feature overview explicitly recommends starting with CLAUDE.md before adding other extensions. This project built the extensions first (skills) but skipped the foundation (CLAUDE.md). Adding it will make every session more productive, including sessions where you are authoring and testing new skills.
- **Source**: [Extend Claude Code](https://docs.anthropic.com/en/docs/agents/claude-code/features-overview) (via MCP)

## Priority Actions

| # | Type | What to do | Why it matters |
|---|------|-----------|----------------|
| 1 | fix | Create a `CLAUDE.md` at the project root with project overview, directory conventions, skill authoring standards, and install instructions | Every session starts blind without it -- Claude has to rediscover the project each time |
| 2 | fix | Update `.claude/settings.local.json` to fix the stale `minimal-framework` paths, or remove the rules if no longer needed | Broken permissions mean the symlink install workflow documented in README does not work with Claude |
| 3 | improve | Create `.claude/settings.json` with the checkpoint `SessionStart` hook pre-configured | Eliminates manual hook setup and gives contributors a working configuration out of the box |
| 4 | improve | Add `.claude/rules/skill-authoring.md` scoped to `**/SKILL.md` with skill quality standards | Enforces consistent skill structure every time Claude edits a skill file |
| 5 | improve | Add the foundation layer (CLAUDE.md + settings) to match the strong components layer already in place | The feature overview docs recommend CLAUDE.md as the starting point -- this project built extensions first but skipped the base |

## Next Steps

To implement these recommendations:
1. Start a new Claude Code session
2. Enter Plan mode (Shift+Tab or /plan)
3. Tell Claude: "Read AUDIT-REPORT.md and create an implementation plan for the priority actions"
4. Review the plan, then execute
