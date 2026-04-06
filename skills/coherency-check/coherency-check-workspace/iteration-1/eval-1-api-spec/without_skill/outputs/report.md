# Coherency Check: API Spec, SDK Docs, and Changelog

## Documents reviewed

- **routes.md** -- API route definitions (the source of truth for endpoint behaviour)
- **sdk-docs.md** -- JavaScript SDK documentation for `@taskflow/sdk`
- **changelog.md** -- Release notes for v2.2.0 and v2.3.0

---

## Inconsistencies found

### 1. Token expiry time

| Document | Value |
|---|---|
| routes.md | `expires_in: 3600` (1 hour) |
| sdk-docs.md | "Token is valid for 24 hours" |
| changelog.md | Not mentioned |

**Conflict.** The API spec says the token expires in 3,600 seconds (1 hour). The SDK docs tell developers the token lasts 24 hours. One of these is wrong. If the API spec is authoritative, the SDK docs need correcting.

---

### 2. Account deletion behaviour (soft-delete vs permanent, recovery window duration)

| Document | Value |
|---|---|
| routes.md | Soft-delete with 30-day recovery window |
| sdk-docs.md | "permanent and immediate, cannot be undone" |
| changelog.md v2.3.0 | 14-day recovery window (changed from "immediate") |
| changelog.md v2.2.0 | Added soft-delete with 30-day recovery window |

**Three-way conflict.** The changelog tells the full story: v2.2.0 introduced soft-delete with a 30-day window, then v2.3.0 shortened it to 14 days. But the API spec still says 30 days (not updated to 14), and the SDK docs still say "permanent and immediate" (never updated at all past the original behaviour). The current correct state, per the changelog, should be: soft-delete with a 14-day recovery window. Both routes.md and sdk-docs.md are stale.

---

### 3. Email verification requirement

| Document | Value |
|---|---|
| routes.md | "Email verification required before first login" |
| sdk-docs.md | Error code `auth/email-not-verified` documented |
| changelog.md v2.3.0 | "Removed email verification requirement for new accounts" |

**Conflict.** The changelog v2.3.0 explicitly removed email verification. But routes.md still states it is required, and the SDK docs still list the `auth/email-not-verified` error code. Both should be updated to reflect the removal.

---

### 4. Pagination max per page

| Document | Value |
|---|---|
| routes.md | Max 50 per page |
| sdk-docs.md | "Max 100 per page" |
| changelog.md v2.3.0 | "Increased pagination max from 50 to 100 items per page" |

**Conflict.** The changelog confirms the max was raised from 50 to 100 in v2.3.0. The SDK docs reflect the new value (100), but routes.md still says 50. Routes.md is stale.

---

### 5. Project colour field: accepted values

| Document | Value |
|---|---|
| routes.md | "Colour must be a valid hex code" |
| sdk-docs.md | "accepts any CSS color value" |
| changelog.md v2.3.0 | "Changed project colour field to accept only hex codes (was previously accepting any CSS colour value)" |

**Conflict.** The changelog confirms the field was restricted to hex-only in v2.3.0. Routes.md correctly reflects this. But the SDK docs still say "any CSS color value" -- stale, needs updating.

---

### 6. Project limit for free-tier users

| Document | Value |
|---|---|
| routes.md | "Max 10 projects per free-tier user" |
| sdk-docs.md | "Free tier: unlimited projects" |
| changelog.md | Not mentioned |

**Conflict.** Direct contradiction with no changelog entry to explain when it changed. Either the limit was quietly removed (and routes.md is stale) or it was never removed (and the SDK docs are wrong). This needs investigation -- there is no changelog entry to resolve the dispute.

---

### 7. Login rate limit

| Document | Value |
|---|---|
| routes.md | 5 attempts per minute |
| sdk-docs.md | "max 10 per minute" |
| changelog.md v2.2.0 | "Added rate limiting to login endpoint (5 attempts per minute)" |

**Conflict.** The API spec and changelog agree on 5 per minute. The SDK docs say 10. The SDK docs are wrong.

---

### 8. SDK default `perPage` value vs API default

| Document | Value |
|---|---|
| routes.md | Default: `per_page=20` |
| sdk-docs.md | Example uses `perPage: 25` |

**Minor inconsistency.** The SDK example passes `perPage: 25`, which is a valid value, but it does not match the API default of 20. Not necessarily a bug, but potentially confusing for developers who might assume 25 is the default.

---

## Summary

| # | Issue | Stale document(s) |
|---|---|---|
| 1 | Token expiry (1h vs 24h) | SDK docs |
| 2 | Deletion behaviour (permanent vs soft-delete, 30d vs 14d) | Routes.md AND SDK docs |
| 3 | Email verification removed | Routes.md AND SDK docs |
| 4 | Pagination max (50 vs 100) | Routes.md |
| 5 | Colour field (hex-only vs any CSS) | SDK docs |
| 6 | Free-tier project limit (10 vs unlimited) | Unknown -- no changelog entry |
| 7 | Login rate limit (5 vs 10 per minute) | SDK docs |
| 8 | Default perPage mismatch (20 vs 25) | SDK docs (minor) |

**Total: 8 inconsistencies.** The changelog is the most internally consistent document and provides the clearest timeline. Routes.md has 3 stale values. SDK docs have 6 stale or incorrect values. One conflict (free-tier project limit) cannot be resolved from the documents alone.
