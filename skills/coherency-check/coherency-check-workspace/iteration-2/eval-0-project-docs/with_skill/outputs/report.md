## Coherency Check: TaskFlow project docs

**3 files checked — 7 contradictions, 2 overlapping definitions, 1 terminology drift issue, 1 stale reference found.**

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
| 3 | **Authentication method and token/session duration** | README.md (Stack section): "JWT authentication with 24-hour token expiry" | SPEC.md (API section): "API key passed in the `X-API-Key` header" — no mention of JWT. SPEC.md (Architecture section): "Session-based authentication with 8-hour session duration" | High |
| 4 | **Task statuses** | README.md (API Overview): `open`, `in_progress`, `review`, `done` | SPEC.md (Data Model): `todo`, `doing`, `review`, `complete` | CONTRIBUTING.md (Task Statuses): `open` -> `in_progress` -> `done` — "There is no review step — we removed it in v2.1" | High |
| 5 | **Rate limit** | README.md (API Overview): "100 requests per minute per user" / CONTRIBUTING.md (Rate Limiting): "100 requests per minute per user" | SPEC.md (API section): "60 requests per minute per API key" | High |
| 6 | **PostgreSQL version** | README.md (Stack section): "PostgreSQL 14" | SPEC.md (Architecture section): "PostgreSQL 15" | Medium |
| 7 | **Deployment target and IaC tooling** | README.md (Deployment): "AWS using the included Terraform configs... ECS Fargate behind an ALB. See `infrastructure/`" / CONTRIBUTING.md (Deployment): "AWS ECS... Terraform configs under `infrastructure/`" | SPEC.md (Deployment): "Google Cloud Run with Cloud SQL... Infrastructure managed via Pulumi. See `deploy/`" | High |

---

### Overlapping Definitions

1. **Task statuses** — All three files define the set of task statuses independently, each with a different list. This is a maintenance hazard on top of being a contradiction: the status enum should be defined in one place and referenced elsewhere.
   - README.md (API Overview): `open`, `in_progress`, `review`, `done`
   - SPEC.md (Data Model): `todo`, `doing`, `review`, `complete`
   - CONTRIBUTING.md (Task Statuses): `open`, `in_progress`, `done` (no `review`)

2. **Deployment process** — All three files describe deployment independently, with conflicting details (cloud provider, IaC tool, directory path). If deployment changes, three files need updating.
   - README.md (Deployment): AWS, Terraform, `infrastructure/`
   - SPEC.md (Deployment): Google Cloud Run, Pulumi, `deploy/`
   - CONTRIBUTING.md (Deployment): AWS ECS, GitHub Actions, Terraform, `infrastructure/`

---

### Terminology Drift

1. **Workspace vs organisation** — README.md and CONTRIBUTING.md use "workspace" as the team container ("10 users per workspace"). SPEC.md uses "organisation" ("25 members per organisation") while also using "workspace" as a data model entity (the `workspaces` table, "Each workspace supports up to 25 members"). It is unclear whether "workspace" and "organisation" are the same concept or different levels of hierarchy.

---

### Stale References

1. **Infrastructure directory path** — README.md and CONTRIBUTING.md reference `infrastructure/` for deployment configs. SPEC.md references `deploy/`. One of these paths is stale (or they are genuinely different directories, but that is not explained anywhere). Note also that CONTRIBUTING.md mentions `.github/workflows/deploy.yml` for the deployment pipeline, which neither of the other files references.

---

### Additional Notes

CONTRIBUTING.md states that the review status was "removed in v2.1 to simplify the workflow." If this is accurate, then:
- README.md is stale — it still lists `review` as a status.
- SPEC.md is stale — it still lists `review` as a status, and uses entirely different status names regardless.

This changelog note from CONTRIBUTING.md is the only temporal anchor across the three files. It suggests CONTRIBUTING.md may reflect the most recent state for statuses, but that does not automatically make it authoritative on other topics.

---

There are 7 contradictions to resolve. I'll walk through each one — tell me which version should be the source of truth, or if you'd like a different value entirely.

**Contradiction #1: Web framework**
- **Option A** (README.md): Node.js 18 with Express
- **Option B** (SPEC.md): Node.js 20 with Fastify

Which should we go with — A, B, or something else? The SPEC.md is typically the more authoritative technical document, but this is a fundamental architectural choice so you'll know which is correct.

**Contradiction #2: Team/workspace size limit**
- **Option A** (README.md): up to 10 users per workspace
- **Option B** (SPEC.md): up to 25 members per organisation

Which should we go with — A, B, or something else?

**Contradiction #3: Authentication method and duration**
- **Option A** (README.md): JWT with 24-hour token expiry
- **Option B** (SPEC.md): Session-based with 8-hour duration, plus API key via `X-API-Key` header

Which should we go with — A, B, or something else? These are very different auth architectures — only one can be what's actually implemented.

**Contradiction #4: Task statuses**
- **Option A** (README.md): `open`, `in_progress`, `review`, `done`
- **Option B** (SPEC.md): `todo`, `doing`, `review`, `complete`
- **Option C** (CONTRIBUTING.md): `open`, `in_progress`, `done` — with a note that `review` was removed in v2.1

CONTRIBUTING.md's changelog note suggests Option C is the most current. Want to confirm?

**Contradiction #5: Rate limit**
- **Option A** (README.md + CONTRIBUTING.md): 100 requests per minute per user
- **Option B** (SPEC.md): 60 requests per minute per API key

Two files agree on 100/min/user. The SPEC says 60/min/API key. Which is correct?

**Contradiction #6: PostgreSQL version**
- **Option A** (README.md): PostgreSQL 14
- **Option B** (SPEC.md): PostgreSQL 15

Which should we go with — A, B, or something else?

**Contradiction #7: Deployment target and IaC tooling**
- **Option A** (README.md + CONTRIBUTING.md): AWS ECS (Fargate), Terraform, `infrastructure/`
- **Option B** (SPEC.md): Google Cloud Run, Cloud SQL, Pulumi, `deploy/`

Two files agree on AWS/Terraform. SPEC.md says GCP/Pulumi. These are entirely different cloud platforms — which is actually in use?
