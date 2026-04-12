# Coherency Check Report

**Files compared:** routes.md (API spec), sdk-docs.md (SDK documentation), changelog.md

---

## Conflicts Found

### 1. Token expiry time

| Source | Value |
|--------|-------|
| routes.md | `expires_in: 3600` (1 hour) |
| sdk-docs.md | "Token is valid for 24 hours" |

**Verdict:** Direct contradiction. One of them is wrong.

---

### 2. Account deletion behaviour

| Source | Value |
|--------|-------|
| routes.md | Soft-delete, 30-day recovery window |
| sdk-docs.md | "permanent and immediate, cannot be undone" |
| changelog v2.3.0 | Changed to 14-day recovery window (was immediate) |
| changelog v2.2.0 | Added soft-delete with 30-day recovery window |

**Verdict:** Three-way conflict. The changelog shows the feature evolved: v2.2.0 introduced 30-day soft-delete, then v2.3.0 shortened it to 14 days. The API spec still says 30 days (stale — should say 14). The SDK docs say "permanent and immediate" which was the pre-v2.2.0 behaviour and is completely outdated.

---

### 3. Rate limit on login

| Source | Value |
|--------|-------|
| routes.md | 5 attempts per minute |
| sdk-docs.md | "max 10 per minute" |
| changelog v2.2.0 | 5 attempts per minute |

**Verdict:** SDK docs contradict both the API spec and the changelog. Should be 5 per minute.

---

### 4. Pagination max per page

| Source | Value |
|--------|-------|
| routes.md | max 50 per page |
| sdk-docs.md | "Max 100 per page" |
| changelog v2.3.0 | Increased max from 50 to 100 |

**Verdict:** The changelog confirms the limit was raised to 100 in v2.3.0. The API spec is stale — still says 50. SDK docs are correct at 100.

---

### 5. Project colour field validation

| Source | Value |
|--------|-------|
| routes.md | Must be a valid hex code |
| sdk-docs.md | "accepts any CSS color value" |
| changelog v2.3.0 | Changed to accept only hex codes (was previously any CSS colour value) |

**Verdict:** The changelog confirms the restriction to hex-only in v2.3.0. The API spec is correct. The SDK docs are stale — still documents the old "any CSS colour" behaviour.

---

### 6. Email verification requirement

| Source | Value |
|--------|-------|
| routes.md | "Email verification required before first login" |
| sdk-docs.md | Lists `auth/email-not-verified` error code |
| changelog v2.3.0 | Removed email verification requirement |

**Verdict:** Both the API spec and SDK docs still reference email verification, but the changelog says it was removed in v2.3.0. Both are stale on this point.

---

### 7. Free-tier project limit

| Source | Value |
|--------|-------|
| routes.md | Max 10 projects per free-tier user |
| sdk-docs.md | "Free tier: unlimited projects" |
| changelog | No mention of change |

**Verdict:** Direct contradiction with no changelog entry explaining when or if the limit was removed. Needs clarification from the team.

---

## Summary

| # | Field | API Spec | SDK Docs | Changelog (latest) | Which is current? |
|---|-------|----------|----------|---------------------|-------------------|
| 1 | Token expiry | 1 hour | 24 hours | — | Unknown — needs verification |
| 2 | Account deletion | 30-day soft-delete | Permanent/immediate | 14-day recovery | Changelog (14 days) |
| 3 | Login rate limit | 5/min | 10/min | 5/min | API spec + changelog (5/min) |
| 4 | Pagination max | 50 | 100 | Raised to 100 | SDK + changelog (100) |
| 5 | Colour validation | Hex only | Any CSS value | Restricted to hex | API spec + changelog (hex only) |
| 6 | Email verification | Required | Referenced | Removed | Changelog (not required) |
| 7 | Free-tier projects | Max 10 | Unlimited | — | Unknown — needs verification |

**Total conflicts: 7**

- API spec is outdated on: deletion window, pagination max, email verification
- SDK docs are outdated on: token expiry (possibly), deletion behaviour, rate limit, colour validation, email verification, free-tier limit
- Two items (token expiry, free-tier limit) have no changelog entry and need human verification to determine the correct value
