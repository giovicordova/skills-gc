## Coherency Check: TaskFlow project documentation

**3 files checked — 7 contradictions, 2 overlaps, 1 terminology drift issue found.**

Files:
- `README.md`
- `SPEC.md`
- `CONTRIBUTING.md`

---

### Contradictions

| # | Issue | File A | File B | Severity |
|---|-------|--------|--------|----------|
| 1 | **Web framework** | README.md (Stack section): "Node.js 18 with Express" | SPEC.md (Architecture section): "Node.js 20 with Fastify" | High |
| 2 | **Team/workspace size limit** | README.md (opening line): "up to 10 users per workspace" | SPEC.md (Architecture + Workspaces sections): "up to 25 members per organisation" | High |
| 3 | **Task statuses** | README.md (API Overview): four statuses — `open`, `in_progress`, `review`, `done` | SPEC.md (Data Model > Tasks): four statuses — `todo`, `doing`, `review`, `complete` | High |
| 3a | *(same topic, third voice)* | CONTRIBUTING.md (Task Statuses): three statuses — `open` → `in_progress` → `done`, explicitly stating "There is no review step — we removed it in v2.1" | — | High |
| 4 | **Authentication method** | README.md (Stack + API Overview): "JWT authentication with 24-hour token expiry", "Bearer token" | SPEC.md (Architecture + API): "Session-based authentication with 8-hour session duration", "API key passed in the `X-API-Key` header" | High |
| 5 | **Rate limit** | README.md (API Overview): "100 requests per minute per user" / CONTRIBUTING.md (Rate Limiting): "100 requests per minute per user" | SPEC.md (API section): "60 requests per minute per API key" | Medium |
| 6 | **Cloud provider and infrastructure** | README.md (Deployment): "AWS using… Terraform… ECS Fargate behind an ALB… `infrastructure/`" / CONTRIBUTING.md (Deployment): "AWS ECS… Terraform configs under `infrastructure/`" | SPEC.md (Deployment): "Google Cloud Run with Cloud SQL… Pulumi… `deploy/`" | High |
| 7 | **PostgreSQL version** | README.md (Stack): "PostgreSQL 14" | SPEC.md (Architecture): "PostgreSQL 15" | Low |

---

### Overlapping Definitions

1. **Deployment process** — All three files describe deployment, each with different details:
   - README.md: AWS, Terraform, ECS Fargate, ALB, `infrastructure/` directory.
   - SPEC.md: Google Cloud Run, Pulumi, Cloud SQL, `deploy/` directory.
   - CONTRIBUTING.md: AWS ECS, GitHub Actions pipeline, Terraform, `infrastructure/` directory.

   README.md and CONTRIBUTING.md broadly agree (AWS + Terraform + `infrastructure/`) but SPEC.md describes a completely different stack (Google Cloud + Pulumi + `deploy/`). This overlap is also captured in Contradiction #6, but the maintenance risk remains: three separate places describe deployment, so any future change requires updating all three.

2. **Getting started / setup instructions** — README.md (Getting Started) and CONTRIBUTING.md (Setup) both describe how to set up the project locally, with slightly different steps:
   - README.md: `docker-compose up` (full), then `npm start` on port 3000.
   - CONTRIBUTING.md: `docker-compose up db` (database only), then `npm run dev` on port 8080.

   The dev server port differs (3000 vs 8080) and the start commands differ (`npm start` vs `npm run dev`). These could be intentional (production-style vs development-style), but it is not stated and could confuse contributors.

---

### Terminology Drift

1. **Grouping entity**: README.md calls it a "workspace" ("up to 10 users per workspace"). SPEC.md calls it an "organisation" ("teams of up to 25 members per organisation") but also uses "workspace" in the data model (`workspace_id`, "Each workspace supports up to 25 members"). It is unclear whether "workspace" and "organisation" are the same concept, nested concepts, or synonyms. CONTRIBUTING.md does not use either term.

---

### Stale References

None identified — all file/directory references (`infrastructure/`, `deploy/`, `.env.example`, `.github/workflows/deploy.yml`) are internal and cannot be verified from these three documents alone. However, note that SPEC.md references `deploy/` while the other two reference `infrastructure/`, which is captured in Contradiction #6.

---

---

There are 7 contradictions to resolve. I'll walk through each one — tell me which version should be the source of truth, or if you'd like a different value entirely.

**Contradiction #1: Web framework**
- **Option A** (README.md): Node.js 18 with Express
- **Option B** (SPEC.md): Node.js 20 with Fastify

Which should we go with — A, B, or something else?

**Contradiction #2: Team/workspace size limit**
- **Option A** (README.md): up to 10 users per workspace
- **Option B** (SPEC.md): up to 25 members per organisation/workspace

Which should we go with — A, B, or something else?

**Contradiction #3: Task statuses**
- **Option A** (README.md): `open`, `in_progress`, `review`, `done` (4 statuses)
- **Option B** (SPEC.md): `todo`, `doing`, `review`, `complete` (4 statuses, different names)
- **Option C** (CONTRIBUTING.md): `open`, `in_progress`, `done` (3 statuses, no review step — says it was removed in v2.1)

Which should we go with — A, B, C, or something else? CONTRIBUTING.md's claim that `review` was removed in v2.1 suggests C may be the most current, but that means both README.md and SPEC.md are stale.

**Contradiction #4: Authentication method**
- **Option A** (README.md): JWT with Bearer token, 24-hour expiry
- **Option B** (SPEC.md): Session-based auth with 8-hour duration, API key in `X-API-Key` header

Which should we go with — A, B, or something else?

**Contradiction #5: Rate limit**
- **Option A** (README.md + CONTRIBUTING.md): 100 requests/min per user
- **Option B** (SPEC.md): 60 requests/min per API key

Two files agree on 100 req/min, so that is likely correct unless the spec intentionally tightened it. Which should we go with?

**Contradiction #6: Cloud provider and infrastructure tooling**
- **Option A** (README.md + CONTRIBUTING.md): AWS ECS, Terraform, `infrastructure/` directory
- **Option B** (SPEC.md): Google Cloud Run, Pulumi, `deploy/` directory

Two files agree on AWS + Terraform. Which should we go with — A, B, or something else?

**Contradiction #7: PostgreSQL version**
- **Option A** (README.md): PostgreSQL 14
- **Option B** (SPEC.md): PostgreSQL 15

Which should we go with — A, B, or something else?

---

For the overlapping definitions, I'd recommend consolidating deployment documentation into a single authoritative location (most likely SPEC.md or a dedicated `DEPLOYMENT.md`) and having the other files reference it rather than redefine it. The setup instructions in README.md and CONTRIBUTING.md could similarly be consolidated — README.md for quick start, CONTRIBUTING.md for the dev-specific workflow, but they should not contradict each other on port numbers.

For the terminology drift between "workspace" and "organisation", I'd recommend picking one term and using it consistently across all three files. Since the data model in SPEC.md already uses `workspace_id`, "workspace" is the natural choice.

Want me to update the files to resolve these once you've decided on each contradiction?
