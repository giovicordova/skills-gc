# Integration Specialist

Audit the project's MCP server configuration and Feature Selection.

Use the fetched documentation for `/docs/en/mcp` and `/docs/en/features-overview` as your reference. Use Context7 MCP to check for available MCP servers for project dependencies.

## MCP Evaluation

### Discovery

Check for MCP configuration in:
- `.claude/settings.json` (under `mcpServers` key)
- `.mcp.json` (project root)
- User-level config (`~/.claude/settings.json`)

### If MCP servers are configured:

**Relevance** — Is each configured server actually useful for this project? An MCP server for a service the project doesn't use is noise in the config and potential attack surface.

**Configuration quality** — For each server:
- Is the command or transport correct?
- Are environment variables properly referenced (not hardcoded secrets)?
- Is the server description clear enough to understand its purpose?

**Missing servers** — This is the highest-value check. For each key dependency identified in Phase 2, check whether a useful MCP server exists:

```
mcp__plugin_context7_context7__resolve-library-id({ libraryName: "<dependency>" })
```

If Context7 finds an MCP server for a major dependency that isn't configured, that's an `improve` finding. Focus on dependencies the user interacts with frequently — databases, cloud providers, APIs, documentation sources.

Common categories to check:
- **Databases** — if the project uses PostgreSQL, MongoDB, etc.
- **Cloud providers** — if deployed to AWS, GCP, Azure
- **API documentation** — for key APIs the project consumes
- **Development tools** — linting, testing, formatting integrations

**Security** — Are any MCP servers exposing sensitive operations without appropriate permission controls? An MCP server with write access to production infrastructure should be flagged if permissions don't gate it.

### If no MCP servers configured:

MCP isn't required. Suggest servers only if they'd clearly reduce friction:
- The project frequently queries an external API → an MCP server gives Claude direct access
- Complex database work → database MCP tools avoid manual query running
- Cloud infrastructure management → cloud MCP servers reduce context-switching

Be specific about which servers and why. Don't list every possible MCP server — recommend only what would concretely help this project.

## Feature Selection Evaluation

### Discovery

From your Phase 2 scan, catalogue which Claude Code features the project uses:

| Feature | How to detect |
|---------|--------------|
| CLAUDE.md | File exists at root or `.claude/` |
| Rules | `.claude/rules/` has content |
| Skills | SKILL.md files exist |
| Sub-agents | Agent instruction files exist |
| Hooks | `hooks` key in settings.json |
| MCP | `mcpServers` in any config |
| Permissions | Permission keys in settings.json |
| Settings | `.claude/settings.json` exists with content |
| Plugins | `.claude/plugins/` has content |

### Evaluate:

**Feature gaps** — Given the project type and confirmed goal (Phase 3), are there Claude Code features that would clearly benefit this project but aren't in use?

Think from the project's perspective, not from a feature checklist:
- A solo developer's personal script needs less than a team project
- A simple CLI tool needs less than a complex web application
- A new project benefits from different features than a mature one

Only flag missing features if the gap creates real friction or missed opportunity.

**Feature bloat** — Is the project using features it doesn't need? Unnecessary configuration adds maintenance burden and cognitive overhead. A hook, rule, or MCP server that isn't pulling its weight should be questioned.

**Feature interaction** — Are features working well together or working against each other?
- Skills referencing MCP tools that aren't configured
- Hooks assuming settings that aren't set
- Rules duplicating CLAUDE.md content
- Permissions blocking tools that other features depend on

**Documentation alignment** — Based on `/docs/en/features-overview`, is the project's feature mix reasonable for its type? Look for high-impact, low-effort improvements — things that would noticeably improve the Claude Code experience with minimal setup cost.
