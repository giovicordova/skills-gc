# TaskFlow Document Coherency Report

**Files reviewed:**
- `README.md`
- `SPEC.md`
- `CONTRIBUTING.md`

---

## Inconsistencies Found

### 1. Team/workspace size limit

| Document | Claim |
|----------|-------|
| README.md | Up to **10 users** per workspace |
| SPEC.md | Up to **25 members** per organisation |
| CONTRIBUTING.md | Not mentioned |

These numbers directly contradict each other. The README says 10, the spec says 25. Decide which is correct and update the other.

### 2. Node.js version

| Document | Claim |
|----------|-------|
| README.md | Node.js **18** |
| SPEC.md | Node.js **20** |
| CONTRIBUTING.md | Node.js **18+** |

README and CONTRIBUTING align on 18 (or 18+), but the spec says 20. If the project actually requires Node 20, the README and CONTRIBUTING guide are out of date. If 18 is correct, the spec is wrong.

### 3. Web framework

| Document | Claim |
|----------|-------|
| README.md | **Express** |
| SPEC.md | **Fastify** |
| CONTRIBUTING.md | Not mentioned |

Express and Fastify are different frameworks. Only one can be correct.

### 4. PostgreSQL version

| Document | Claim |
|----------|-------|
| README.md | PostgreSQL **14** |
| SPEC.md | PostgreSQL **15** |
| CONTRIBUTING.md | Not mentioned |

Minor version difference, but still a contradiction.

### 5. Authentication method

| Document | Claim |
|----------|-------|
| README.md | **JWT** with Bearer token, **24-hour** token expiry |
| SPEC.md | **Session-based** authentication with **8-hour** session duration; API key via `X-API-Key` header |
| CONTRIBUTING.md | Not mentioned |

These are fundamentally different authentication approaches. JWT Bearer tokens and session-based auth with API keys are not the same thing. The token/session duration also differs (24h vs 8h).

### 6. Task statuses

| Document | Claim |
|----------|-------|
| README.md | `open`, `in_progress`, `review`, `done` (4 statuses) |
| SPEC.md | `todo`, `doing`, `review`, `complete` (4 statuses) |
| CONTRIBUTING.md | `open`, `in_progress`, `done` (3 statuses -- no `review` step) |

Three documents, three different answers. The status names differ across all three files (`open` vs `todo`, `in_progress` vs `doing`, `done` vs `complete`). On top of that, CONTRIBUTING.md explicitly states the `review` status was removed in v2.1, while both README and SPEC still include a review status.

### 7. Rate limiting

| Document | Claim |
|----------|-------|
| README.md | **100 requests/min per user** |
| SPEC.md | **60 requests/min per API key** |
| CONTRIBUTING.md | **100 requests/min per user** |

README and CONTRIBUTING agree (100/min per user), but the spec says 60/min per API key. The unit also differs: "per user" vs "per API key".

### 8. Deployment target and infrastructure

| Document | Claim |
|----------|-------|
| README.md | **AWS ECS Fargate** behind ALB; **Terraform**; config in `infrastructure/` |
| SPEC.md | **Google Cloud Run** with Cloud SQL; **Pulumi**; config in `deploy/` |
| CONTRIBUTING.md | **AWS ECS**; **GitHub Actions** pipeline; **Terraform** in `infrastructure/` |

README and CONTRIBUTING mostly agree on AWS + Terraform + `infrastructure/`, but the spec describes a completely different stack: Google Cloud Run + Pulumi + `deploy/`. These cannot both be true for the same project.

### 9. Dev server port

| Document | Claim |
|----------|-------|
| README.md | Port **3000** |
| CONTRIBUTING.md | Port **8080** |
| SPEC.md | Not mentioned |

The README says the server launches on port 3000; the contributing guide says the dev server runs on port 8080.

### 10. Redis usage

| Document | Claim |
|----------|-------|
| README.md | Redis for **session caching** |
| SPEC.md | Redis for **caching and pub/sub** |
| CONTRIBUTING.md | Redis backs the **rate limiting** sliding window |

Each document assigns a different primary role to Redis. These are not necessarily contradictions (Redis could do all three), but the inconsistent framing will confuse readers about what Redis actually does in the system.

### 11. Startup command

| Document | Claim |
|----------|-------|
| README.md | `npm start` |
| CONTRIBUTING.md | `npm run dev` |

README uses `npm start`; CONTRIBUTING uses `npm run dev`. These are likely different scripts (production vs development), which is reasonable, but worth confirming that both exist and are documented correctly.

---

## Summary

| # | Issue | Severity |
|---|-------|----------|
| 1 | Team size limit (10 vs 25) | High |
| 2 | Node.js version (18 vs 20) | Medium |
| 3 | Web framework (Express vs Fastify) | High |
| 4 | PostgreSQL version (14 vs 15) | Low |
| 5 | Auth method (JWT vs session/API key) | High |
| 6 | Task statuses (3 different sets) | High |
| 7 | Rate limit (100 vs 60, per user vs per API key) | Medium |
| 8 | Deployment (AWS+Terraform vs GCP+Pulumi) | High |
| 9 | Dev server port (3000 vs 8080) | Low |
| 10 | Redis role described differently | Low |
| 11 | Startup command (npm start vs npm run dev) | Low |

**11 inconsistencies found. 5 are high severity** -- meaning a reader following one document would build or configure something fundamentally different from what another document describes.

The spec (SPEC.md) is the most divergent file. It disagrees with the other two on framework, cloud provider, infrastructure tool, authentication, rate limits, task statuses, and team size. If the spec represents the intended future state, the README and CONTRIBUTING guide need a full rewrite. If the README and CONTRIBUTING guide reflect the current system, the spec needs correcting.
