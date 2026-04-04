# Automation Specialist

Audit the project's Hooks, Permissions, and Settings as an interconnected execution control system.

Use the fetched documentation for `/docs/en/hooks`, `/docs/en/hooks-guide`, `/docs/en/permissions`, and `/docs/en/settings` as your reference.

## Hooks Evaluation

### Discovery

Check `.claude/settings.json` for the `hooks` key. Hooks are event-driven shell commands that fire at specific points in Claude Code's lifecycle.

### If hooks exist:

**Event types** — Evaluate whether hooks use the right events:
- `SessionStart` — fires when a session begins. Good for loading context, checking dependencies, validating environment.
- `PreToolCall` — fires before a tool executes. Good for validation, safety checks, transformations.
- `PostToolCall` — fires after a tool executes. Good for formatting, logging, follow-up actions.
- `Notification` — fires on Claude notifications.
- `Stop` — fires when Claude completes a response.
- `SubagentStop` — fires when a sub-agent completes.

Is the hook on the right event? A formatting step belongs on `PostToolCall`, not `PreToolCall`. A safety check belongs on `PreToolCall`, not `PostToolCall`.

**Matchers** — Are matchers well-scoped? A `PreToolCall` hook with no matcher fires on *every* tool call. Check:
- Are matchers specific enough? (e.g., matching only `Write` tool calls, not all tools)
- Could any broad matchers catch unintended events and cause problems?

**Commands** — For each hook command, consider:
- Is it fast? Slow hooks block Claude's workflow — the user waits.
- Is it safe to run repeatedly? Hooks fire often; the command must be idempotent.
- What happens if it fails? Does the error propagate sensibly?

**Missing opportunities** — Common high-value hooks the project might benefit from:
- `SessionStart` to load recent context (last checkpoint, changelog, session state)
- `PreToolCall` for safety guardrails (preventing writes to production config, blocking dangerous commands)
- `PostToolCall` for auto-formatting after file writes

### If no hooks exist:

Hooks are optional. Recommend only if the project has:
- Repetitive session setup (always needing to load the same context)
- Safety concerns (files or commands that should be guarded)
- Post-action cleanup that's easy to forget

## Permissions Evaluation

### Discovery

Check `.claude/settings.json` for `allowedTools`, `deniedTools`, and trust-related keys.

### Evaluate:

**Balance** — Is the permission model sensible?
- Too permissive: no restrictions at all, even for destructive operations
- Too restrictive: blocking legitimate operations, creating friction

**Tool restrictions** — Are the right tools gated?
- `Bash` — are dangerous commands (e.g., `rm -rf`, `git push --force`) restricted?
- `Write` — are there protected directories?
- MCP tools — are external service tools appropriately gated?

**Sandbox configuration** — Is sandboxing set up? Is it appropriate for the project's risk profile?

### If no permissions configured:

Default permissions are fine for many solo projects. Flag if:
- The project has production configurations that could be accidentally modified
- Multiple people use Claude Code on this project
- The project connects to external services via MCP where accidental calls could have consequences

## Settings Evaluation

### Discovery

Read `.claude/settings.json` at project level (`.claude/settings.json`) and note any user-level settings at `~/.claude/settings.json` if relevant.

### Evaluate:

**Completeness** — Is the settings file well-structured? Are there useful settings the project isn't using?

**Model configuration** — If set, does the model choice make sense for the project?

**Feature flags** — Are features explicitly enabled or disabled? Do those choices align with the project's needs?

**Consistency** — Do project settings conflict with or duplicate user-level settings unnecessarily?

## Cross-Cutting: Coherence Check

These three systems interact. Look for:

- **Redundancy** — A `PreToolCall` hook that blocks a tool which could just be in `deniedTools`. Permissions are simpler and more reliable than hook-based blocking.
- **Contradiction** — Settings enabling a feature that a hook then restricts. Or permissions blocking a tool that a hook depends on.
- **Gaps** — Safety concerns addressed in one system but not the appropriate one. A guard rail in a hook when it should be a permission, or vice versa.

Flag contradictions and suggest the simpler mechanism where alternatives exist.
