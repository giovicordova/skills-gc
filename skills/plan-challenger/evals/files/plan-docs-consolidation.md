# Plan: Consolidate Project Documentation to 4 Files Max

## Context
A SaaS project (Next.js frontend, Express API, PostgreSQL) has accumulated 14 documentation files across the repo. The team is 3 developers + 1 freelance designer. Docs are frequently outdated because nobody remembers which file to update. Goal: reduce to 4 files maximum so there's always a clear place to look and update.

## Current files
```
README.md                  — project overview, setup instructions
CONTRIBUTING.md            — git workflow, PR conventions, code style
ARCHITECTURE.md            — system design, folder structure, data flow
API.md                     — REST endpoint reference (47 endpoints)
DATABASE.md                — schema docs, migration guide, seed data
DEPLOYMENT.md              — Railway deployment, env vars, CI/CD pipeline
TESTING.md                 — test strategy, how to run, coverage targets
SECURITY.md                — auth flow, rate limiting, input validation
CHANGELOG.md               — version history
TROUBLESHOOTING.md         — common errors and fixes
ONBOARDING.md              — new developer setup guide
DESIGN-SYSTEM.md           — component library, tokens, Figma links
CLAUDE.md                  — AI assistant instructions
.env.example               — environment variable template
```

## Option A: Merge by Audience (Recommended)

Consolidate into 4 files based on who reads them:

1. **README.md** — Everything a new developer needs: project overview, setup, onboarding, contributing guidelines, git workflow, troubleshooting
2. **ARCHITECTURE.md** — Everything about how the system works: system design, API reference, database schema, security model, deployment, testing strategy
3. **CHANGELOG.md** — Keep as-is
4. **CLAUDE.md** — Keep as-is

### Steps
1. Merge ONBOARDING.md, CONTRIBUTING.md, TROUBLESHOOTING.md content into README.md
2. Merge API.md, DATABASE.md, DEPLOYMENT.md, SECURITY.md, TESTING.md into ARCHITECTURE.md
3. Move DESIGN-SYSTEM.md content into ARCHITECTURE.md under a "Frontend" section
4. Delete the 10 removed files
5. Update all internal cross-references
6. Add a table of contents to README.md and ARCHITECTURE.md

### Risks
- README.md becomes long (~800 lines)
- ARCHITECTURE.md becomes very long (~2000+ lines)
- Git blame history is lost for moved content

## Option B: Merge by Lifecycle

1. **README.md** — Overview + setup + onboarding
2. **DEVELOPMENT.md** — Contributing, testing, troubleshooting, design system
3. **OPERATIONS.md** — Deployment, security, database, API reference
4. **CHANGELOG.md** — Keep as-is

### Risks
- CLAUDE.md is dropped (merged into README.md)
- API reference in OPERATIONS.md is odd — developers use it during development
- Where does architecture overview go? Split across DEVELOPMENT.md and OPERATIONS.md

## Option C: Merge Everything

1. **README.md** — Everything except changelog
2. **CHANGELOG.md** — Keep as-is
3. **CLAUDE.md** — Keep as-is
4. **(one slot unused)**

### Risks
- README.md becomes 3000+ lines
- Impossible to navigate without extensive TOC
- Every commit touches the same file — merge conflicts guaranteed

## Decision
Going with Option A. It keeps the audience split clean and README.md stays the entry point.

## Implementation Steps
1. Create backup branch
2. Execute merges per Option A
3. Run link checker for broken cross-references
4. Delete old files
5. Update CLAUDE.md to reference new structure
6. Team review before merging
