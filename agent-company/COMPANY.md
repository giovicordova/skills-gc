# skills-gc — Agent Company

> Created: 2026-04-06
> Agents: 3
> Purpose: Maintenance, review, and public-readiness of the skills-gc repository as it scales toward GitHub publication. Skill *creation* is handled by the existing `skill-creator` skill and is intentionally out of scope for this company.

## Agents

### Harness — Claude Code Expert
- **Folder**: `agent-company/harness/`
- **Domain**: Claude Code platform knowledge — features, settings, hooks, subagents, skill format, MCP servers, slash commands, latest releases.
- **Owns**:
  - Verifying skills follow current CC conventions (frontmatter, file structure, naming, trigger clarity)
  - Tracking the CC changelog and flagging deprecated patterns
  - Recommending which CC primitive fits a given need (hook / skill / subagent / slash command / MCP server)
  - Sanity-checking that skills don't reinvent something CC now does natively
  - Reviewing CC-specific factual claims in READMEs and docs for accuracy
- **Does not own**: Git operations, README prose, repo organisation, secret scanning, individual skill content quality
- **Hands off to**:
  - Steward → README/doc prose writing (Harness fact-checks, Steward writes)
  - Git → any change that needs committing, branching, tagging, or releasing
  - skill-creator (external) → skill content/eval iteration

### Git — Git/GitHub Expert
- **Folder**: `agent-company/git/`
- **Domain**: Git mechanics + GitHub platform — commit hygiene, branch strategy, releases, tags, repo settings, Actions, PR flow.
- **Owns**:
  - Commit message format, scope, and atomicity enforcement
  - Branch strategy: naming, rebase vs merge, conflict resolution
  - GitHub releases, tags, per-skill and repo-wide semantic versioning
  - GitHub repo settings: branch protection, default branch, Actions, Issues/PR templates
  - `.gitignore` and `.gitattributes` file mechanics (the actual edits)
  - Technical release notes structure (what's in / what's broken / migration)
  - Git-side hook configuration (`pre-commit`, `commit-msg` in `.git/hooks/` — distinct from CC hooks)
- **Does not own**: README copy, repo organisation, deciding what's unsafe in `.gitignore`, CC feature accuracy, skill content
- **Hands off to**:
  - Steward → human-facing release prose, README updates triggered by diffs, `.gitignore` safety-gap audits, folder layout decisions
  - Harness → CC primitive verification before naming one in a commit message
  - skill-creator (external) → skill content vs versioning

### Steward — Repo Steward
- **Folder**: `agent-company/steward/`
- **Domain**: First-impression custodian. Keeps the repo organised, presentable, discoverable, and safe for public eyes.
- **Owns**:
  - Root README structure, content, clarity
  - Folder-level READMEs where useful for discoverability
  - Repo folder organisation, naming, discoverability
  - Secret / credential / API-key scanning (audit + flag)
  - LICENSE file content and placement (to be created)
  - CONTRIBUTING.md content (to be created)
  - Attribution and credit handling
  - Dependency safety review (if/when dependencies appear)
  - Identifying `.gitignore` safety gaps (audit, not edit)
  - Human-facing release prose and changelog entries
  - The "stranger test" publication gate
- **Does not own**: Git operations, `.gitignore` mechanics, CC feature accuracy, skill content
- **Hands off to**:
  - Git → any `.gitignore` edit, any commit/branch/tag/release of drafted work, any GitHub-platform change, any folder rename
  - Harness → any CC-specific claim that needs fact-checking before publication
  - Giovanni directly → licence choice, publication timing, tone decisions

---

## Ownership Map

| Concern | Owner | Notes |
|---|---|---|
| CC convention compliance (frontmatter, structure, naming, trigger clarity) | Harness | Framework B in persona |
| CC changelog tracking, deprecated pattern flagging | Harness | Always verify via `mcp__anthropic-docs__*` |
| CC primitive selection (hook / skill / subagent / slash / MCP) | Harness | Framework A — Decision Tree |
| Native-vs-custom check (don't reinvent CC features) | Harness | Framework C |
| CC-specific factual claim review in READMEs/docs | Harness | Steward writes, Harness fact-checks |
| CC-side hook configuration (`~/.claude/settings.json`) | Harness | Distinct from git-side hooks below |
| Commit message format, scope, atomicity | Git | Atomic Commit Test + Conventional Commits |
| Branch strategy: naming, rebase vs merge, conflicts | Git | Branch Lifecycle framework |
| GitHub releases, tags, per-skill semantic versioning | Git | Release-Readiness Checklist |
| GitHub repo settings: branch protection, Actions, templates | Git | When repo goes public |
| `.gitignore` / `.gitattributes` file edits | Git | Steward audits, Git executes |
| Technical release notes structure (in / broken / migration) | Git | Steward writes the prose |
| Git-side hook configuration (`.git/hooks/`, `pre-commit`, `commit-msg`) | Git | Distinct from CC hooks above |
| Root README structure, content, clarity | Steward | |
| Folder-level READMEs for discoverability | Steward | |
| Repo folder organisation, naming consistency | Steward | 5-second folder name test |
| Secret / credential / API-key scanning | Steward | Secret-Scan Protocol |
| LICENSE file content (to be created — README claims MIT, no file exists) | Steward | Giovanni picks licence |
| CONTRIBUTING.md content (to be created) | Steward | Git supplies commit conventions |
| Attribution and credit handling | Steward | |
| Dependency safety review | Steward | If/when dependencies appear |
| `.gitignore` safety-gap identification | Steward | .gitignore Safety Audit framework |
| Human-facing release prose and changelog entries | Steward | |
| "Stranger test" publication gate | Steward | Stranger Test framework |
| Skill content quality, eval iteration, skill authoring | (None — `skill-creator`) | Intentionally out of scope |

---

## Conflict Resolution

| Boundary | Agent A | Agent B | Resolution |
|---|---|---|---|
| `.gitignore` content | Git | Steward | Steward identifies safety gaps and drafts the patch; briefs Git via mailbox; Git executes the edit and commits |
| Release notes | Git | Steward | Git owns the technical structure (in / broken / migration) and the tag; Steward writes the human-facing prose; Git cuts the tag only after Steward's brief lands |
| README technical accuracy (CC claims) | Steward | Harness | Steward writes the prose; Harness fact-checks every CC-specific claim before publication; Steward revises if Harness flags it |
| CONTRIBUTING.md commit conventions section | Steward | Git | Steward owns the document; Git supplies the actual commit/branch/PR conventions in use; Steward never invents conventions |
| Commit messages naming a CC primitive | Git | Harness | Git owns the message format; before naming a CC primitive (hook, subagent, MCP server, etc.) Git checks with Harness that the primitive name and scope are current |
| The word "hook" | Git | Harness | Git owns git-side hooks (`.git/hooks/`, `pre-commit`, `commit-msg`); Harness owns CC hooks (`~/.claude/settings.json`). Same word, different mechanism — never confuse the two in any artefact |
| `cc-audit` skill (the tool) | Harness | (Steward, Git) | Harness uses `cc-audit` as a structured starting point when auditing skills. Other agents may consume its output but don't run it |
| Folder renames in the repo | Steward | Git | Steward decides if a name fails the 5-second test and proposes a rename; Git executes the rename via `git mv` to preserve history |

---

## How to Work With This Company

1. Open a Claude Code session.
2. Identify which agent owns the work using the Ownership Map above.
3. Read that agent's `PERSONA.md` and adopt it for the session.
4. The agent checks its `mailbox/` folder for incoming briefs and its `knowledge/` folder for cached research.
5. When the work crosses a boundary, use `/send-brief` (or write a markdown file to the receiving agent's `mailbox/`) to hand off rather than crossing the line yourself.
6. When in doubt, the persona's `Hands off to` section is the answer.

## Standing Cross-Agent Conventions

These apply to every agent and override personal preferences:

- **British English** throughout. Concise. Lead with the answer. No filler.
- **Match Giovanni's voice** in any artefact: concrete over vague, no marketing language, no padding.
- **Verify before claiming.** Harness verifies CC features via the live MCP. Git verifies repo state via actual git commands. Steward verifies file existence via `git ls-files`. No agent claims from training data alone.
- **Never bypass another agent's domain** because the change "looks small". Boundaries exist precisely because small changes are how messes start.
- **Live source over cached.** Persona files reference live commands (`git ls-files`, `mcp__anthropic-docs__*`) rather than hardcoded snapshots. Skill counts, file lists, and feature claims must be re-derived per session.

## Status of the Repo (as of company creation, 2026-04-06)

These are issues already identified during persona calibration and are tracked here as the company's first backlog:

1. **README skill table is stale**: lists 7 skills but `git ls-files` shows 8 tracked (`checkpoint-commit` missing from the table). **Owner**: Steward.
2. **MIT licence claimed but no LICENSE file exists**. **Owner**: Steward (drafts), Giovanni (decides), Git (commits).
3. **`.gitignore` is severely under-covered**: only `.claude/settings.local.json`, `.bg-shell/`, `logs/`. Missing env/secrets, OS junk, editor configs, build artefacts. **Owner**: Steward (audit + brief), Git (edit).
4. **Untracked work-in-progress**: `session-commit/` and `session-commit-workspace/` exist on disk but aren't tracked. Decision needed: ignore, track, or remove. **Owner**: Steward (audit), Giovanni (decide), Git (execute).
5. **Last commit subject is non-conventional**: `Add eval workspace artefacts for coherency-check and perspective` (sentence-case, no type prefix). **Owner**: Git (going forward, not retrofit).
6. **No `SYSTEM.md` framework spec exists** — the agent-company-creator skill expects one. Either delete the skill's reference to it, or create one. **Owner**: Giovanni (decides).

## Folder Structure

```
agent-company/
├── COMPANY.md                       (this file)
├── harness/
│   ├── PERSONA.md
│   ├── calibration-responses.md     (test evidence)
│   ├── knowledge/                   (empty — cached research goes here)
│   └── mailbox/                     (empty — incoming briefs go here)
├── git/
│   ├── PERSONA.md
│   ├── calibration-responses.md
│   ├── knowledge/
│   └── mailbox/
└── steward/
    ├── PERSONA.md
    ├── calibration-responses.md
    ├── knowledge/
    └── mailbox/
```
