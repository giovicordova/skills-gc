# Instructions Specialist

Audit the project's instruction system: CLAUDE.md files and Rules.

Use the fetched documentation for `/docs/en/memory` as your reference.

## CLAUDE.md Evaluation

### Existence and Placement

Check for CLAUDE.md at:
- Project root (most common)
- `.claude/CLAUDE.md` (alternative)
- Subdirectories (folder-scoped instructions)

Multiple CLAUDE.md files at different levels is a feature, not a problem — Claude Code merges them with the most specific taking precedence. Evaluate whether the hierarchy makes sense for the project.

**If no CLAUDE.md exists:** this is a `fix` finding. Every project using Claude Code benefits from a CLAUDE.md — it's Claude's only persistent memory of the project across sessions.

### Content Quality

Evaluate each CLAUDE.md against these criteria:

**Project context** — Does it explain what the project is and does? Claude starts every session without memory, so CLAUDE.md is how it understands the project. Without context, Claude makes assumptions that waste the user's time.

**Coding conventions** — Does it state preferences for style, patterns, frameworks, testing? If the project has opinions (e.g., "functional components only", "no ORMs"), they belong here. Their absence means Claude guesses — and guesses wrong.

**Conciseness** — CLAUDE.md loads into every session's context window. Every line costs tokens and dilutes what matters. Flag files over ~200 lines as potentially bloated. Look for:
- Tutorial-style explanations of how Claude Code works (it already knows)
- Copy-pasted external documentation
- Logging or session data that doesn't belong here
- Information that changes frequently (better suited to rules or settings)

**Accuracy** — Does the content match the actual codebase? Look for outdated file paths, references to deleted features, instructions that contradict current code. Stale instructions are worse than no instructions — they actively mislead.

**Actionability** — Are instructions specific enough to follow? "Write good code" is useless. "Use Zod for all API request validation" is actionable. Check that each instruction tells Claude *what to do*, not just *what to value*.

### Structure

Good CLAUDE.md files use clear sections. Common effective patterns:
- Project overview (what this is, how it works)
- Key commands (build, test, lint, deploy)
- Architecture notes (where things live, how they connect)
- Conventions and preferences
- Things to avoid

The structure should match the project's needs. A simple script needs less structure than a monorepo.

## Rules Evaluation

Check `.claude/rules/` for rule files.

### If rules exist:

**Scope** — Are rules properly targeted? Rules can match specific file patterns with globs. A TypeScript convention rule should target `*.ts` files, not everything. Overly broad rules add noise to every interaction.

**Overlap with CLAUDE.md** — Do any rules duplicate CLAUDE.md content? Having the same instruction in two places creates maintenance burden and potential contradictions. The split should be clear: CLAUDE.md for project-wide context, rules for file-scoped instructions.

**Granularity** — Each rule should address one concern. A rule covering "TypeScript style AND testing conventions AND deployment steps" should be three separate rules — it's clearer and allows proper scoping.

### If rules don't exist:

Not always a problem. Rules are most valuable when:
- Different parts of the codebase have different conventions (frontend vs backend)
- There are file-type-specific instructions ("all migration files must...")
- CLAUDE.md is getting long and some content could be scoped to specific files

If the project has extensive CLAUDE.md content that only applies to certain file types, suggest migrating that content to scoped rules.

## CLAUDE.md + Rules Coherence

These two systems should complement each other. Check:
- **Duplication** — same instruction in both places
- **Contradiction** — rules that conflict with CLAUDE.md
- **Misplacement** — project-wide instructions in rules, or file-specific instructions in CLAUDE.md
- **Gaps** — important conventions not captured in either system
