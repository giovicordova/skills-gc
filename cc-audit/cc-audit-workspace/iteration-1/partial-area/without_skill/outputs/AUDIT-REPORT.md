# Claude Code Audit Report

> Audited: 2026-04-04 | Mode: MCP (anthropic-docs)
> Project: skills-gc | Goal: Collection of custom Claude Code skills (checkpoint, plan-challenger, verify, cc-audit, perspective, website-audit)

## Current State

| Area | What it is | Status | Findings |
|------|-----------|--------|----------|
| CLAUDE.md | Your project's instructions to Claude | fix | 2 |
| Rules | Targeted instructions scoped to specific files | improve | 1 |
| Skills | Reusable workflows Claude can invoke | improve | 2 |
| Sub-agents | Isolated Claude sessions for specific tasks | good | 1 |
| Hooks | Automated actions before/after Claude acts | improve | 3 |
| Permissions | What Claude can do without asking | fix | 2 |
| Settings | Project-level Claude Code configuration | improve | 2 |
| MCP | Connections to external tools and services | good | 2 |
| Features | Overall use of available Claude Code features | improve | 1 |

## Findings

---

### Instructions (CLAUDE.md + Rules)

#### [fix] No project-level CLAUDE.md

- **Current**: This repository has no `CLAUDE.md` and no `.claude/CLAUDE.md`. The only instructions Claude receives when working in this repo come from the user-level `~/.claude/CLAUDE.md`, which contains personal style preferences but nothing about this project's structure, conventions, or how skills should be written.
- **Recommendation**: Create a project-level `CLAUDE.md` (either at the repo root or at `.claude/CLAUDE.md`) describing: (a) what this repo is (a collection of Claude Code skills), (b) the file structure convention each skill must follow (directory with `SKILL.md`, `evals/`, optional `agents/`, `workspace/`, `references/`), (c) frontmatter conventions used across skills, (d) that each skill must have an `evals/evals.json`, and (e) build/test commands if any. Running `/init` would generate a starting point automatically.
- **Project relevance**: Without a project CLAUDE.md, anyone (including you) opening a new Claude Code session in this repo starts blind. Claude has to rediscover the structure every time, which is especially wasteful in a skills-authoring repo where consistency is critical.
- **Source**: [How Claude remembers your project -- Set up a project CLAUDE.md](https://docs.anthropic.com/en/docs/memory) (via MCP)

#### [fix] No project-level rules directory

- **Current**: There is no `.claude/rules/` directory in this project. The user-level `~/.claude/rules/` has a single symlinked rule (`docs-hygiene.md`), but nothing project-specific.
- **Recommendation**: Add a `.claude/rules/` directory with at least one rule scoped to `**/SKILL.md` files, enforcing the frontmatter format (required `name`, `description` fields), maximum line-count guidelines, and the finding format used across skills. Path-specific rules keep these instructions out of context until Claude actually edits a SKILL.md file, saving tokens.
- **Project relevance**: This is a skills-authoring repo. Having rules that fire when editing SKILL.md files would enforce consistency across all six skills without bloating every session's context.
- **Source**: [Organize rules with .claude/rules/ -- Path-specific rules](https://docs.anthropic.com/en/docs/memory) (via MCP)

#### [good] User-level CLAUDE.md is well-structured

- **Current**: `~/.claude/CLAUDE.md` is concise (32 lines), well-organised with clear sections (User, Style, Honesty, Before Building, Technical Language, Research), and uses specific, actionable instructions. This is a solid foundation for personal preferences across all projects.
- **Source**: [Write effective instructions](https://docs.anthropic.com/en/docs/memory) (via MCP)

---

### Components (Skills + Sub-agents)

#### [improve] Most skills from this repo are not installed

- **Current**: This repo contains 6 skills (checkpoint, verify, plan-challenger, perspective, cc-audit, website-audit), but only `perspective` is symlinked into `~/.claude/skills/`. The other five are not installed. The `checkpoint-workspace` and `plan-challenger-workspace` directories exist in `~/.claude/skills/` (likely leftover workspace artefacts), but the actual skill directories with their `SKILL.md` files are absent.
- **Recommendation**: Symlink each skill you want available globally:
  ```bash
  ln -s /Users/giovannicordova/Documents/02_projects/skills-gc/checkpoint ~/.claude/skills/checkpoint
  ln -s /Users/giovannicordova/Documents/02_projects/skills-gc/verify ~/.claude/skills/verify
  ln -s /Users/giovannicordova/Documents/02_projects/skills-gc/plan-challenger ~/.claude/skills/plan-challenger
  ln -s /Users/giovannicordova/Documents/02_projects/skills-gc/cc-audit ~/.claude/skills/cc-audit
  ln -s /Users/giovannicordova/Documents/02_projects/skills-gc/website-audit ~/.claude/skills/website-audit
  ```
- **Project relevance**: You built these skills specifically to use them. Without the symlinks, they are only available when Claude Code is launched from within this repo's directory (via subdirectory auto-discovery), not in other projects where you'd actually want to invoke `/checkpoint` or `/verify`.
- **Source**: [Extend Claude with skills -- Where skills live](https://docs.anthropic.com/en/docs/skills) (via MCP)

#### [improve] cc-audit skill references AskUserQuestion but subagent context may not support it

- **Current**: The cc-audit `SKILL.md` (Phase 3) says "Use `AskUserQuestion` to present..." and "This step is mandatory. Do not skip it." However, if this skill is invoked in a context where `AskUserQuestion` is unavailable (e.g. as a subagent, in headless mode, or from background execution), Phase 3 will fail or be skipped silently.
- **Recommendation**: Add a fallback: "If `AskUserQuestion` is not available (subagent context, headless mode), proceed with stated assumptions and note them in the report."
- **Project relevance**: You are currently running this audit as a subagent, which demonstrates the exact scenario where this limitation matters.
- **Source**: [Create custom subagents -- Run subagents in foreground or background](https://docs.anthropic.com/en/docs/sub-agents) (via MCP)

#### [good] Sub-agent structure in cc-audit is well-designed

- **Current**: The cc-audit skill uses an `agents/` subdirectory with specialist instruction files (instructions-specialist.md, components-specialist.md, automation-specialist.md, integration-specialist.md, adversarial-reviewer.md). This follows the documented pattern of using supporting files to keep the main SKILL.md focused while providing detailed reference material.
- **Source**: [Extend Claude with skills -- Add supporting files](https://docs.anthropic.com/en/docs/skills) (via MCP)

---

### Automation (Hooks + Permissions + Settings)

#### [good] Notification hook is correctly configured

- **Current**: The user-level `~/.claude/settings.json` has a `Notification` hook with an empty matcher (fires on all notification types) that triggers a macOS native notification via `osascript`. This matches the exact pattern from the official documentation.
- **Source**: [Automate workflows with hooks -- Get notified when Claude needs input](https://docs.anthropic.com/en/docs/hooks-guide) (via MCP)

#### [improve] SessionStart hook matcher is overly broad

- **Current**: The first `SessionStart` hook in `~/.claude/settings.json` uses `"matcher": "startup|resume|clear|compact"`. This is a regex that matches all four possible SessionStart sources. It is functionally equivalent to using an empty matcher `""` or `"*"`, which would be simpler and more maintainable.
- **Recommendation**: Replace `"startup|resume|clear|compact"` with `""` (empty string) to match all sources. Alternatively, if you only want context injection on new sessions and compaction (not resume/clear), narrow the matcher to `"startup|compact"`.
- **Project relevance**: Minor readability issue. The current config works, but listing all four values explicitly creates maintenance risk -- if Anthropic adds a fifth SessionStart source in the future, the hook would silently miss it.
- **Source**: [Hooks reference -- SessionStart](https://docs.anthropic.com/en/docs/hooks) (via MCP)

#### [improve] PostToolUse hook on Write|Edit runs a frontend quality gate globally

- **Current**: The `PostToolUse` hook with matcher `"Edit|Write"` runs `frontend-quality-gate.cjs` after every file edit in every project. This is a 13KB script running globally from user-level settings.
- **Recommendation**: Consider whether this hook should be scoped to frontend projects only. If it is only relevant to projects with HTML/CSS/JS, move it to a project-level `.claude/settings.json` in those repos, or add a check at the top of the script that exits early if no frontend files were edited (by inspecting the `tool_input.file_path` from stdin JSON).
- **Project relevance**: When editing `SKILL.md` files in this skills-gc repo, the frontend quality gate runs unnecessarily. It likely exits cleanly, but it adds latency to every edit.
- **Source**: [Automate workflows with hooks -- Configure hook location](https://docs.anthropic.com/en/docs/hooks-guide) (via MCP)

#### [fix] Project-level permissions reference non-existent paths

- **Current**: `.claude/settings.local.json` in this project allows four specific Bash commands:
  ```
  Bash(rm -rf /Users/giovannicordova/.claude/skills/checkpoint)
  Bash(ln -s /Users/giovannicordova/Documents/02_projects/minimal-framework/checkpoint ...)
  Bash(rm -rf /Users/giovannicordova/.claude/skills/verify)
  Bash(ln -s /Users/giovannicordova/Documents/02_projects/minimal-framework/verify ...)
  ```
  The symlink targets point to `/Users/giovannicordova/Documents/02_projects/minimal-framework/checkpoint` and `.../verify`, but **this directory does not exist**. The `minimal-framework` project is either renamed or removed. These permissions are stale and non-functional.
- **Recommendation**: Update the paths to point to this repo (`skills-gc`) instead of `minimal-framework`. Or better yet, remove these permissions entirely and create the symlinks manually or via a setup script, since pre-approving `rm -rf` commands (even for specific paths) is an unnecessary risk.
- **Project relevance**: These were likely set up during early development when the repo had a different name. They now serve no purpose and are misleading.
- **Source**: [Configure permissions -- Permission rule syntax](https://docs.anthropic.com/en/docs/permissions) (via MCP)

#### [good] User-level deny rules are sensible

- **Current**: `~/.claude/settings.json` denies destructive git operations: `git push --force`, `git push --force-with-lease`, `git reset --hard`, and `git clean -fd`. This is a solid safety net.
- **Source**: [Configure permissions -- Use specifiers for fine-grained control](https://docs.anthropic.com/en/docs/permissions) (via MCP)

#### [improve] No shared project settings.json

- **Current**: There is no `.claude/settings.json` (shared/committable) in this project. All settings are either user-level or in `.claude/settings.local.json` (gitignored). This means anyone cloning this repo gets zero project-specific Claude Code configuration.
- **Recommendation**: Create a `.claude/settings.json` with: (a) a `SessionStart` hook referencing `logs/` for checkpoint continuity (the checkpoint skill's SKILL.md describes this setup but it is not actually configured), and (b) any project-specific permission rules or hooks that collaborators should inherit.
- **Project relevance**: The checkpoint skill's own SKILL.md (lines 105-123) describes a SessionStart hook that reads the latest checkpoint log on startup. This hook is not configured anywhere in this repo. It would make a natural addition to a shared project settings file.
- **Source**: [Claude Code settings -- Settings files](https://docs.anthropic.com/en/docs/settings) (via MCP)

#### [improve] skipDangerousModePermissionPrompt is enabled

- **Current**: `~/.claude/settings.json` sets `"skipDangerousModePermissionPrompt": true`. This suppresses the warning when entering bypass-permissions mode.
- **Recommendation**: This is a conscious choice and you may have good reasons. Just be aware that it removes a safety guardrail. If you rarely use bypass mode, consider removing it so the prompt serves as a deliberate gate.
- **Project relevance**: Low risk for a skills-authoring repo, but worth noting for awareness.
- **Source**: [Configure permissions -- Permission modes](https://docs.anthropic.com/en/docs/permissions) (via MCP)

---

### Integration (MCP + Features)

#### [good] MCP servers are well-chosen and functional

- **Current**: Three MCP servers are configured at the user level (`~/.claude/.mcp.json`):
  1. **anthropic-docs** -- local Node server pointing to a custom docs MCP build. This is the foundation for the cc-audit skill and for fetching documentation during sessions.
  2. **lighthouse** -- web performance auditing via `@danielsogl/lighthouse-mcp@latest`. Relevant for the website-audit skill.
  3. **vercel** -- remote HTTP MCP at `https://mcp.vercel.com`. Useful for deployment workflows.

  All three are user-scoped (stored in `~/.claude/.mcp.json`), meaning they are available across all projects. No project-scoped `.mcp.json` exists in this repo.
- **Source**: [Connect Claude Code to tools via MCP -- MCP installation scopes](https://docs.anthropic.com/en/docs/mcp) (via MCP)

#### [good] Anthropic docs MCP pre-approved in permissions

- **Current**: `~/.claude/settings.json` includes `mcp__anthropic-docs__get_doc_page` and `mcp__anthropic-docs__search_anthropic_docs` in the allow list. This means the cc-audit skill (and any session) can query documentation without permission prompts, which is correct for a read-only information source.
- **Source**: [Configure permissions -- MCP](https://docs.anthropic.com/en/docs/permissions) (via MCP)

#### [improve] High number of enabled plugins may affect context budget

- **Current**: `~/.claude/settings.json` has 15 plugins enabled (`enabledPlugins`), including superpowers, frontend-design, code-review, stripe, skill-creator, code-simplifier, claude-code-setup, claude-md-management, firecrawl, coderabbit, context7, figma, feature-dev, and a custom `sa` plugin. Each plugin can register skills whose descriptions consume context budget. With 15 plugins plus your 76+ installed skills, you may be hitting the skill description character budget (2% of context window).
- **Recommendation**: Run `/context` in a session to check whether any skills are being excluded due to budget limits. Disable plugins you don't actively use. For skills you want available but don't want Claude auto-invoking, add `disable-model-invocation: true` to their frontmatter to remove them from the description budget.
- **Project relevance**: In a skills-authoring repo, you want all your custom skills to be discoverable. Plugin skill descriptions competing for the same budget could crowd them out.
- **Source**: [Extend Claude with skills -- Claude doesn't see all my skills](https://docs.anthropic.com/en/docs/skills) (via MCP)

---

## Priority Actions

| # | Type | What to do | Why it matters |
|---|------|-----------|----------------|
| 1 | fix | Update or remove `.claude/settings.local.json` -- the 4 permission rules reference `minimal-framework/` which no longer exists | Stale config that points nowhere; misleading for anyone reading the settings |
| 2 | fix | Create a project-level `CLAUDE.md` describing this repo's structure, skill conventions, and file layout | Every new session in this repo starts without project context; Claude has to rediscover the structure each time |
| 3 | improve | Symlink the 5 missing skills (checkpoint, verify, plan-challenger, cc-audit, website-audit) into `~/.claude/skills/` | You built these skills but can only use them when working inside this specific directory |
| 4 | improve | Add a `.claude/settings.json` with the SessionStart hook described in checkpoint's SKILL.md | The checkpoint skill documents a hook for auto-loading the latest log on session start, but it is not actually configured |
| 5 | improve | Add a `.claude/rules/` directory with a path-scoped rule for `**/SKILL.md` files | Enforces consistent skill authoring conventions without bloating every session's context |

## Next Steps

To implement these recommendations:
1. Start a new Claude Code session
2. Enter Plan mode (Shift+Tab or /plan)
3. Tell Claude: "Read cc-audit-workspace/iteration-1/partial-area/without_skill/outputs/AUDIT-REPORT.md and create an implementation plan for the priority actions"
4. Review the plan, then execute
