# TaskFlow Documentation Coherency Report

## Files Reviewed

- README.md
- SPEC.md
- CONTRIBUTING.md

## Inconsistencies Found

### 1. Team/Workspace Size Limit

| File | Stated Limit |
|------|-------------|
| README.md | Up to 10 users per workspace |
| SPEC.md | Up to 25 members per organisation |
| CONTRIBUTING.md | Not mentioned |

**Conflict:** README says 10, SPEC says 25. These need to align.

---

### 2. Node.js Version

| File | Version |
|------|---------|
| README.md | Node.js 18 |
| SPEC.md | Node.js 20 |
| CONTRIBUTING.md | Node.js 18+ |

**Conflict:** README pins Node 18, SPEC pins Node 20. CONTRIBUTING says "18+" which is ambiguous — it would allow both, but the intended runtime version is unclear.

---

### 3. Web Framework

| File | Framework |
|------|-----------|
| README.md | Express |
| SPEC.md | Fastify |
| CONTRIBUTING.md | Not mentioned |

**Conflict:** These are two different frameworks. Only one can be correct.

---

### 4. PostgreSQL Version

| File | Version |
|------|---------|
| README.md | PostgreSQL 14 |
| SPEC.md | PostgreSQL 15 |
| CONTRIBUTING.md | Not mentioned |

**Conflict:** README says 14, SPEC says 15.

---

### 5. Authentication Method

| File | Method |
|------|--------|
| README.md | JWT with 24-hour token expiry |
| SPEC.md | Session-based with 8-hour duration, API key via X-API-Key header |
| CONTRIBUTING.md | Not mentioned |

**Conflict:** Three different auth stories — JWT tokens, sessions, and API keys. These may coexist (e.g., API keys for external consumers, JWT for users) but the docs don't explain the relationship, making them appear contradictory.

---

### 6. Task Statuses

| File | Statuses |
|------|----------|
| README.md | `open`, `in_progress`, `review`, `done` |
| SPEC.md | `todo`, `doing`, `review`, `complete` |
| CONTRIBUTING.md | `open`, `in_progress`, `done` (no review step, removed in v2.1) |

**Conflict:** Three different sets of status names across three files. Additionally, CONTRIBUTING.md explicitly states there is no review step, while both README and SPEC include a review status.

---

### 7. Rate Limiting

| File | Limit |
|------|-------|
| README.md | 100 requests/min per user |
| SPEC.md | 60 requests/min per API key |
| CONTRIBUTING.md | 100 requests/min per user |

**Conflict:** README and CONTRIBUTING agree (100/min/user), but SPEC says 60/min/API key. The unit also differs (per user vs. per API key).

---

### 8. Deployment Target and Infrastructure

| File | Cloud / Infra |
|------|--------------|
| README.md | AWS ECS Fargate, Terraform, `infrastructure/` directory |
| SPEC.md | Google Cloud Run, Cloud SQL, Pulumi, `deploy/` directory |
| CONTRIBUTING.md | AWS ECS, Terraform, `infrastructure/` directory |

**Conflict:** README and CONTRIBUTING point to AWS with Terraform in `infrastructure/`. SPEC points to Google Cloud with Pulumi in `deploy/`. These are fundamentally different deployment stories.

---

### 9. Dev Server Port

| File | Port |
|------|------|
| README.md | 3000 |
| CONTRIBUTING.md | 8080 |

**Conflict:** README says port 3000, CONTRIBUTING says port 8080.

---

### 10. Redis Usage

| File | Purpose |
|------|---------|
| README.md | Session caching |
| SPEC.md | Caching and pub/sub |
| CONTRIBUTING.md | Rate limiting (sliding window) |

**Minor conflict:** Each file describes a different use for Redis. These could all be true simultaneously, but together they paint an unclear picture of Redis's role.

---

## Summary

These three documents have **9 direct contradictions** and 1 minor inconsistency. The most critical conflicts involve:

1. **Stack identity** — Express vs. Fastify, AWS vs. GCP, Terraform vs. Pulumi
2. **Data model** — task status names and lifecycle disagree across all three files
3. **Auth model** — JWT vs. sessions vs. API keys with no explanation of how they relate

Before sharing with the team, pick one source of truth (likely SPEC.md as the canonical technical reference) and update README and CONTRIBUTING to match it.
