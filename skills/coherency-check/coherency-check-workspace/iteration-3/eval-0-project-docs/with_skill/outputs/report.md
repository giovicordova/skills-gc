## Coherency Check: TaskFlow Project Documentation

**3 files checked — 10 contradictions, 1 overlapping definition, 1 terminology drift issue found.**

Files:
- `README.md`
- `SPEC.md`
- `CONTRIBUTING.md`

---

### Contradictions

| # | Issue | File A | File B | Severity |
|---|-------|--------|--------|----------|
| 1 | Team/workspace size limit | README: "up to 10 users per workspace" | SPEC: "up to 25 members per organisation" | High |
| 2 | Node.js version | README: "Node.js 18" | SPEC: "Node.js 20" | High |
| 3 | Web framework | README: "Express" | SPEC: "Fastify" | High |
| 4 | PostgreSQL version | README: "PostgreSQL 14" | SPEC: "PostgreSQL 15" | Medium |
| 5 | Authentication mechanism | README: "JWT authentication with 24-hour token expiry" | SPEC: "Session-based authentication with 8-hour session duration" | High |
| 6 | Task statuses | README: `open`, `in_progress`, `review`, `done` (4 statuses) / SPEC: `todo`, `doing`, `review`, `complete` (4 statuses, different names) | CONTRIBUTING: `open` → `in_progress` → `done` (3 statuses, "no review step — we removed it in v2.1") | High |
| 7 | Rate limit | README: "100 requests per minute per user" / CONTRIBUTING: "100 requests per minute per user" | SPEC: "60 requests per minute per API key" | Medium |
| 8 | Deployment target | README: "AWS ECS Fargate behind an ALB" / CONTRIBUTING: "AWS ECS" | SPEC: "Google Cloud Run with Cloud SQL" | High |
| 9 | Infrastructure-as-Code tool | README: "Terraform" / CONTRIBUTING: "Terraform" | SPEC: "Pulumi" | High |
| 10 | Infrastructure directory path | README: `infrastructure/` / CONTRIBUTING: `infrastructure/` | SPEC: `deploy/` | Medium |

**Additional contradictions within the above groupings:**

- **Dev server port**: README says port 3000 (`npm start`), CONTRIBUTING says port 8080 (`npm run dev`). Severity: Low — these could be different commands for prod vs dev, but it's ambiguous.
- **API authentication method**: README says "Bearer token", SPEC says "X-API-Key header". Severity: High — developers will implement the wrong auth pattern.

---

### Overlapping Definitions

**Deployment process** — all three files describe deployment but with conflicting details:
- README: AWS ECS Fargate + Terraform + `infrastructure/` directory
- SPEC: Google Cloud Run + Pulumi + `deploy/` directory
- CONTRIBUTING: AWS ECS + GitHub Actions pipeline + Terraform + `infrastructure/` directory

This is not merely overlapping — it's actively contradictory. But the fact that three files each independently describe deployment means any update will need to touch all three.

---

### Terminology Drift

**"workspace" vs "organisation"** — README and CONTRIBUTING use "workspace" to describe the team container. SPEC uses "organisation" for the same concept. The data model in SPEC then also has a `workspace_id` field, making it unclear whether "organisation" and "workspace" are the same entity or different levels of hierarchy.

---

### Stale References

**CONTRIBUTING's claim that review status was "removed in v2.1"** — If this is accurate, then both README and SPEC are stale (they still list a review status). However, the SPEC references a `/v2` base URL, suggesting it may describe the current version. The three files cannot all be correct about task statuses.

---

## Step 5: Classification and Research

### Factual vs Preference Classification

| # | Contradiction | Classification | Reasoning |
|---|---------------|---------------|-----------|
| 1 | Team size (10 vs 25) | Preference | Project-specific business decision |
| 2 | Node.js version (18 vs 20) | Preference | Both are valid LTS versions; project must pick one |
| 3 | Framework (Express vs Fastify) | Preference | Both are valid Node.js frameworks; project chose one |
| 4 | PostgreSQL version (14 vs 15) | Preference | Both are supported; project must pick one |
| 5 | Auth mechanism (JWT vs session-based) | Preference | Architectural decision specific to the project |
| 6 | Task statuses (4 vs 4-different-names vs 3) | Preference | Domain model decision — only the team knows what's current |
| 7 | Rate limit (100 vs 60) | Preference | Business/operational decision |
| 8 | Deployment target (AWS vs GCP) | Preference | Infrastructure decision |
| 9 | IaC tool (Terraform vs Pulumi) | Preference | Tooling decision |
| 10 | Infrastructure directory | Preference | Naming convention |
| — | Dev port (3000 vs 8080) | Preference | Configuration choice |
| — | API auth (Bearer vs X-API-Key) | Preference | Design decision |

**All contradictions are preference-based.** None can be resolved by consulting external documentation — they are all project-specific decisions where only the team knows the intended current state.

---

## Needs Your Call

These are grouped by theme to reduce decision fatigue:

### Architecture & Stack

**#2–3: Node.js version and framework**
- Option A (README / CONTRIBUTING): Node.js 18 with Express
- Option B (SPEC): Node.js 20 with Fastify
- *Which is the actual stack?*

**#4: PostgreSQL version**
- Option A (README): PostgreSQL 14
- Option B (SPEC): PostgreSQL 15

**#5: Authentication**
- Option A (README): JWT with 24-hour token expiry, passed as Bearer token
- Option B (SPEC): Session-based, 8-hour duration, via X-API-Key header

### Business Rules

**#1: Team size limit**
- Option A (README): 10 users per workspace
- Option B (SPEC): 25 members per organisation

**#6: Task statuses**
- Option A (README): `open`, `in_progress`, `review`, `done`
- Option B (SPEC): `todo`, `doing`, `review`, `complete`
- Option C (CONTRIBUTING): `open`, `in_progress`, `done` (review removed in v2.1)
- *CONTRIBUTING claims review was removed — is that current?*

**#7: Rate limit**
- Option A (README + CONTRIBUTING): 100 requests/min/user
- Option B (SPEC): 60 requests/min/API key

### Infrastructure

**#8–9: Deployment + IaC**
- Option A (README + CONTRIBUTING): AWS ECS + Terraform + `infrastructure/`
- Option B (SPEC): Google Cloud Run + Pulumi + `deploy/`
- *Two files agree on AWS/Terraform — is SPEC outdated, or did the project migrate?*

### Terminology

For the "workspace" vs "organisation" drift: I'd recommend picking one term and using it everywhere. README's "workspace" aligns with the data model's `workspace_id` field, making it the more natural choice — but this needs confirmation.

---

## Recommendations

Given that README and CONTRIBUTING agree on most points (AWS, Terraform, Express, port, rate limit, `infrastructure/`), and SPEC disagrees on nearly everything, the most likely scenario is:

1. **SPEC is either outdated or aspirational** (describing a planned migration), or
2. **SPEC was written for a different version** and the other docs weren't updated to match.

Either way, one authoritative source of truth needs to be designated — then the other two files should be updated to align.

---

*Want me to update the files to resolve these once you've made your calls on the preference decisions above?*
