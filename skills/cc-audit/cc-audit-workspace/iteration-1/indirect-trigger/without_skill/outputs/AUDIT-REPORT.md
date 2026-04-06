# Claude Code Audit Report

> Audited: 2026-04-04 | Mode: MCP (anthropic-docs)
> Project: skills-gc | Goal: Collection of reusable Claude Code skills with eval frameworks

## Current State

| Area | What it is | Status | Findings |
|------|-----------|--------|----------|
| CLAUDE.md | Your project's instructions to Claude | fix | 3 |
| Rules | Targeted instructions scoped to specific files | fix | 2 |
| Skills | Reusable workflows Claude can invoke | good | 3 |
| Sub-agents | Isolated Claude sessions for specific tasks | improve | 2 |
| Hooks | Automated actions before/after Claude acts | fix | 3 |
| Permissions | What Claude can do without asking | improve | 2 |
| Settings | Project-level Claude Code configuration | fix | 3 |
| MCP | Connections to external tools and services | improve | 2 |
| Features | Overall use of available Claude Code features | improve | 2 |

## Findings

---

### Instructions (CLAUDE.md + Rules)

#### [fix] No project CLAUDE.md exists

- **Current**: The project has no `CLAUDE.md`, no `.claude/CLAUDE.md`, and no `CLAUDE.local.md`. Claude starts every session in this repo with zero project-specific context.
- **Recommendation**: Create a `CLAUDE.md` at the project root. It should include: what this repo is (a collection of Claude Code skills), the directory convention (each skill lives in its own folder with `SKILL.md` + `evals/`), how to install a skill (`ln -s`), how to test one (run the eval framework), and any naming or writing conventions you follow. Run `/init` to generate a starting point, then refine.
- **Project relevance**: This is a repo about teaching Claude how to behave. Without a CLAUDE.md, Claude has no idea what it is working on when you open a session here. Every session starts with you re-explaining the project.
- **Source**: [CLAUDE.md files](https://docs.anthropic.com/en/docs/claude-code/memory#claudemd-files) -- "CLAUDE.md files are markdown files that give Claude persistent instructions for a project." (via MCP)

#### [fix] No `.claude/rules/` directory

- **Current**: The project has no rules directory. All six skills have their own conventions (naming, frontmatter structure, eval format, supporting files layout), but none of this is captured as rules.
- **Recommendation**: Create `.claude/rules/` with at least two files:
  - `skill-conventions.md` -- naming rules, required frontmatter fields, directory structure, SKILL.md writing guidelines
  - `eval-conventions.md` -- how evals are structured, what `evals.json` should contain, grading criteria
  You could also add path-scoped rules for specific skill types. For example, a rule scoped to `website-audit/**` could document that skill's unique dependency requirements.
- **Project relevance**: You are building skills that other people (and Claude) will use. Consistency matters. Rules ensure that every new skill follows the same structure without you having to explain it each time.
- **Source**: [Organize rules with .claude/rules/](https://docs.anthropic.com/en/docs/claude-code/memory#organize-rules-with-clauderules) -- "For larger projects, you can organize instructions into multiple files using the .claude/rules/ directory." (via MCP)

#### [good] User-level CLAUDE.md is well written

- **Current**: Your `~/.claude/CLAUDE.md` has clear sections (User, Style, Honesty, Before Building, Technical Language, Research) with specific, actionable instructions. It is concise -- under 50 lines.
- **Project relevance**: This works well. The non-developer framing and "plain language" instruction carry into every session, including sessions in this repo. No changes needed.
- **Source**: [Write effective instructions](https://docs.anthropic.com/en/docs/claude-code/memory#write-effective-instructions) -- "Specific, concise, well-structured instructions work best." (via MCP)

---

### Components (Skills + Sub-agents)

#### [good] Skills are well structured and follow the standard

- **Current**: All six skills (checkpoint, verify, plan-challenger, perspective, cc-audit, website-audit) use proper YAML frontmatter with `name`, `description`, and appropriate optional fields. They live in their own directories with `SKILL.md` as the entrypoint. Each has an `evals/` folder. The more complex skills (cc-audit, website-audit, perspective) use supporting files (`agents/`, `references/`, `modules/`, `scripts/`).
- **Project relevance**: This is the core of the repo and it is done right. The frontmatter is thorough, descriptions are trigger-rich (so Claude knows when to invoke them), and the supporting file pattern keeps SKILL.md focused.
- **Source**: [Extend Claude with skills](https://docs.anthropic.com/en/docs/claude-code/skills) -- "Each skill is a directory with SKILL.md as the entrypoint." (via MCP)

#### [good] Smart use of `context: fork` and `disable-model-invocation`

- **Current**: `website-audit` and `perspective` both use `context: fork` (run in isolated subagent context) and `disable-model-invocation: true` (user-triggered only). They also specify `allowed-tools` to restrict what they can access.
- **Project relevance**: These are heavyweight skills with side effects (crawling websites, writing reports). Running them forked and user-triggered-only is the correct pattern. This prevents Claude from accidentally invoking a 20-page website crawl.
- **Source**: [Control who invokes a skill](https://docs.anthropic.com/en/docs/claude-code/skills#control-who-invokes-a-skill) -- "Use disable-model-invocation: true for workflows with side effects." (via MCP)

#### [improve] No custom sub-agents defined at the project level

- **Current**: The project has no `.claude/agents/` directory. The cc-audit skill references specialist agents in its `agents/` subfolder, but these are instruction files read inline -- not actual sub-agent definitions that Claude Code can delegate to.
- **Recommendation**: Consider creating project-level sub-agents for recurring tasks in this repo. For example:
  - A `skill-tester` agent that runs evals for a given skill
  - A `skill-reviewer` read-only agent that audits a SKILL.md against your conventions
  These would use the `.claude/agents/` directory and proper frontmatter (`name`, `description`, `tools`, `model`).
- **Project relevance**: You have 6 skills, each with evals. A sub-agent that can run and compare eval results across skills would save you repeating instructions. User-level agents already exist (you have 35 in `~/.claude/agents/`), but project-specific ones for this repo's workflows are missing.
- **Source**: [Create custom subagents](https://docs.anthropic.com/en/docs/claude-code/sub-agents) -- "Project subagents (.claude/agents/) are ideal for subagents specific to a codebase." (via MCP)

#### [improve] cc-audit's "specialist agents" are just instruction files, not real sub-agents

- **Current**: The cc-audit skill has an `agents/` folder with files like `instructions-specialist.md` and `adversarial-reviewer.md`. These are read as inline instructions during the audit -- they are not registered Claude Code sub-agents.
- **Recommendation**: This works, but you could make these actual sub-agents using `context: fork` in the skill or by creating them as proper agents in `.claude/agents/`. Real sub-agents would run in isolated context, which is important for a skill that reads 9+ documentation pages and does extensive analysis. The current approach risks filling the context window.
- **Project relevance**: The cc-audit skill is your most complex one. Running each specialist in its own context (as a real forked sub-agent) would produce better results on long audits and protect the main conversation from context bloat.
- **Source**: [Subagents help you preserve context](https://docs.anthropic.com/en/docs/claude-code/sub-agents) -- "Preserve context by keeping exploration and implementation out of your main conversation." (via MCP)

---

### Automation (Hooks + Permissions + Settings)

#### [fix] No project-level hooks configured

- **Current**: There is no `.claude/settings.json` at the project root. The checkpoint skill describes a `SessionStart` hook that should auto-load the latest checkpoint log, but this hook does not exist anywhere in the project. The skill says "One-time setup (skip if already done)" and provides the hook JSON, but it was never installed.
- **Recommendation**: Create `.claude/settings.json` in the project root with the SessionStart hook from the checkpoint skill:
  ```json
  {
    "hooks": {
      "SessionStart": [
        {
          "matcher": "startup",
          "hooks": [
            {
              "type": "command",
              "command": "f=$(ls -1 logs/*.md 2>/dev/null | sort -r | head -1); [ -n \"$f\" ] && cat \"$f\""
            }
          ]
        }
      ]
    }
  }
  ```
  This means every new session in this project automatically picks up where the last one left off.
- **Project relevance**: You already designed this feature into the checkpoint skill. It just was never actually set up. Without it, the checkpoint skill writes logs that nobody reads unless they remember to look.
- **Source**: [Automate workflows with hooks](https://docs.anthropic.com/en/docs/claude-code/hooks-guide) -- "Unlike CLAUDE.md instructions which are advisory, hooks are deterministic and guarantee the action happens." (via MCP)

#### [fix] `settings.local.json` has stale permission rules pointing to wrong paths

- **Current**: `.claude/settings.local.json` contains permission rules referencing `/Users/giovannicordova/Documents/02_projects/minimal-framework/checkpoint` and `minimal-framework/verify`. The project is called `skills-gc`, not `minimal-framework`. These symlink commands would create skills pointing to a different (possibly outdated or nonexistent) directory.
- **Recommendation**: Update the paths to point to this project:
  ```
  /Users/giovannicordova/Documents/02_projects/skills-gc/checkpoint
  /Users/giovannicordova/Documents/02_projects/skills-gc/verify
  ```
  Or remove these rules entirely if they are no longer needed (the skills might already be installed).
- **Project relevance**: These stale paths could cause skill installation to silently point to the wrong source, meaning you would be testing old versions of skills without realising it.
- **Source**: [Configure permissions](https://docs.anthropic.com/en/docs/claude-code/permissions) -- Permission allow rules should reference correct paths. (via MCP)

#### [good] User-level hooks are well configured

- **Current**: Your `~/.claude/settings.json` has hooks for: SessionStart (context restoration), PostToolUse (frontend quality gate on Write/Edit, GSD context monitor), and Notification (macOS desktop notifications). You also have destructive git commands in the deny list.
- **Project relevance**: This is a strong setup. The notification hook means you get alerted when Claude needs input -- useful during long skill runs. The deny rules for `git push --force`, `git reset --hard`, etc. are a sensible safety net.
- **Source**: [Hooks reference](https://docs.anthropic.com/en/docs/claude-code/hooks) (via MCP)

#### [improve] Permission rules in `settings.local.json` are too narrow

- **Current**: The local settings only allow four specific Bash commands (the stale symlink operations). There are no project-level permission rules for common operations in this repo, like running eval scripts or managing skill files.
- **Recommendation**: If you create a project-level `settings.json`, add permission rules for operations common to this project:
  ```json
  {
    "permissions": {
      "allow": [
        "Bash(ln -s *)",
        "Bash(ls -1 logs/*)"
      ]
    }
  }
  ```
  Keep the list short -- only pre-approve what you actually repeat. Your user-level settings already handle most common cases.
- **Project relevance**: Pre-approving symlink commands saves you from clicking "allow" every time you install or reinstall a skill.
- **Source**: [Permission rule syntax](https://docs.anthropic.com/en/docs/claude-code/permissions#permission-rule-syntax) (via MCP)

#### [fix] No project-level `settings.json` -- relying entirely on user settings

- **Current**: All Claude Code configuration for this project comes from `~/.claude/settings.json` (user-level). There is no `.claude/settings.json` at the project root.
- **Recommendation**: Create `.claude/settings.json` with project-specific settings. At minimum:
  - The SessionStart hook for checkpoint auto-loading
  - Permission rules for common project operations
  This file should be committed to git so anyone using the repo gets the same baseline configuration.
- **Project relevance**: This is a repo meant to be shared (it has install instructions in the README). Without project-level settings, anyone who clones it gets zero Claude Code configuration. They would need to set up hooks and permissions manually.
- **Source**: [Configuration scopes](https://docs.anthropic.com/en/docs/claude-code/settings#configuration-scopes) -- "Project scope (.claude/ in repository) affects all collaborators on this repository, shared via git." (via MCP)

---

### Integration (MCP + Features)

#### [improve] No `.mcp.json` for project-level MCP server sharing

- **Current**: No `.mcp.json` exists in the project root. The cc-audit skill requires the `anthropic-docs` MCP server to function, but there is no project-level configuration ensuring it is available.
- **Recommendation**: Create a `.mcp.json` at the project root declaring the MCP servers that skills in this repo depend on:
  ```json
  {
    "mcpServers": {
      "anthropic-docs": {
        "command": "npx",
        "args": ["-y", "@anthropic-ai/anthropic-docs-mcp"]
      }
    }
  }
  ```
  This way, anyone who clones the repo and runs Claude Code will be prompted to approve the server, rather than discovering mid-audit that it is missing.
- **Project relevance**: The cc-audit skill explicitly checks for this MCP server in Phase 1 and stops if it is unavailable. Declaring it at project level prevents that failure.
- **Source**: [MCP installation scopes - Project scope](https://docs.anthropic.com/en/docs/claude-code/mcp#project-scope) -- "Project-scoped servers enable team collaboration by storing configurations in a .mcp.json file." (via MCP)

#### [improve] Plugin count at user level is high (15 plugins) -- potential context cost

- **Current**: Your user-level settings enable 15 plugins (superpowers, frontend-design, code-review, stripe, skill-creator, firecrawl, coderabbit, figma, feature-dev, and more). Each plugin adds skill descriptions to context.
- **Recommendation**: Review whether all 15 plugins are needed in every project. You can disable plugins per-project by adding to `.claude/settings.json`:
  ```json
  {
    "enabledPlugins": {
      "stripe@claude-plugins-official": false,
      "figma@claude-plugins-official": false
    }
  }
  ```
  For a skills development repo, you probably do not need Stripe, Figma, or frontend-design plugins active.
- **Project relevance**: More plugins means more skill descriptions loaded into context at session start. The documentation warns that skill descriptions are capped at 2% of context and skills may be excluded if the budget is exceeded. In a project where you are developing and testing your own skills, you want maximum context budget for your skills, not for Stripe.
- **Source**: [Understand context costs](https://docs.anthropic.com/en/docs/claude-code/features-overview#context-cost-by-feature) -- "Skill descriptions load at session start so Claude can decide when to use them." Also: [Skill not triggering](https://docs.anthropic.com/en/docs/claude-code/skills#claude-doesnt-see-all-my-skills) -- "The budget scales dynamically at 2% of the context window." (via MCP)

---

## Priority Actions

| # | Type | What to do | Why it matters |
|---|------|-----------|----------------|
| 1 | fix | Create `CLAUDE.md` at the project root describing what this repo is, directory conventions, and how to work with skills | Every session currently starts blind. This is the single highest-impact change. |
| 2 | fix | Create `.claude/settings.json` with the SessionStart hook from the checkpoint skill | The checkpoint skill writes session logs, but nothing reads them automatically. The hook closes this loop. |
| 3 | fix | Fix stale paths in `.claude/settings.local.json` (references `minimal-framework` instead of `skills-gc`) | Wrong paths could silently install old skill versions. |
| 4 | improve | Create `.claude/rules/skill-conventions.md` defining the standard skill directory structure, frontmatter requirements, and eval format | Ensures consistency across all 6 skills and any new ones. |
| 5 | improve | Add `.mcp.json` declaring the `anthropic-docs` MCP server that cc-audit requires | Prevents the cc-audit skill from failing when cloned to a new machine. |

## Next Steps

To implement these recommendations:
1. Start a new Claude Code session in this project
2. Enter Plan mode (Shift+Tab or /plan)
3. Tell Claude: "Read cc-audit-workspace/iteration-1/indirect-trigger/without_skill/outputs/AUDIT-REPORT.md and create an implementation plan for the priority actions"
4. Review the plan, then execute
