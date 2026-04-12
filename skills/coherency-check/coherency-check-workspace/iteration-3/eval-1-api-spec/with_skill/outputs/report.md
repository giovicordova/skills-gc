## Coherency Check: TaskFlow API spec, SDK docs, and changelog

**3 files checked — 6 contradictions, 1 overlap, 1 terminology drift found.**

---

### Contradictions

| # | Issue | File A | File B | Severity |
|---|-------|--------|--------|----------|
| 1 | Token expiry duration | routes.md (Authentication): `expires_in: 3600` (1 hour) | sdk-docs.md (Authentication): "Token is valid for 24 hours" | High |
| 2 | Account deletion behaviour | routes.md (DELETE /users/me): "Soft-deletes the user account" + "30-day recovery window" | sdk-docs.md (Users): "permanent and immediate, cannot be undone" | High |
| 3 | Account deletion recovery window | routes.md (DELETE /users/me): "30-day recovery window" | changelog.md (v2.3.0): "Account deletion now has a 14-day recovery window (was immediate)" | High |
| 4 | Login rate limit | routes.md (POST /auth/login): "5 attempts per minute" | sdk-docs.md (Error Handling): "max 10 per minute" | High |
| 5 | Email verification requirement | routes.md (POST /auth/register): "Email verification required before first login" | changelog.md (v2.3.0): "Removed email verification requirement for new accounts" | Medium |
| 6 | Free-tier project limit | routes.md (POST /projects): "Max 10 projects per free-tier user" | sdk-docs.md (Projects): "Free tier: unlimited projects" | High |

#### Temporal analysis (using changelog as timeline)

The changelog (v2.3.0, 2026-03-15) resolves several ambiguities:

- **#3 (recovery window):** Changelog says recovery window moved from immediate → 30-day (v2.2.0), then 30-day → 14-day (v2.3.0). Routes.md still says "30-day" — stale since v2.3.0. SDK-docs says "immediate" — stale since v2.2.0.
- **#5 (email verification):** Changelog explicitly removed the requirement in v2.3.0. Routes.md still states it's required — stale since v2.3.0. SDK-docs correctly shows the `auth/email-not-verified` error code, which is now a dead code path.
- **Pagination max:** Changelog says increased from 50 to 100. Routes.md says "max 50" — stale since v2.3.0. SDK-docs says "max 100" — current.
- **Colour field:** Changelog says changed to hex-only in v2.3.0. Routes.md says "valid hex code" — current. SDK-docs says "accepts any CSS color value" — stale since v2.3.0.

---

### Overlapping Definitions

**Pagination parameters:** Both routes.md and sdk-docs.md define pagination defaults but disagree on `per_page` default (20 vs 25). Both files own this definition — there's no single source of truth.

---

### Terminology Drift

**colour vs color:** Routes.md uses British spelling (`colour`), SDK-docs uses American spelling (`color`). The parameter name in the API body uses `colour` but the SDK property uses `color`. If these refer to the same field in HTTP requests, one will break.

---

### Stale References

- sdk-docs.md still documents the `auth/email-not-verified` error code, but the changelog removed email verification entirely in v2.3.0. This error can no longer be triggered.

---

## Step 5: Classification and Research

### Factual vs Preference

| # | Issue | Classification | Reasoning |
|---|-------|---------------|-----------|
| 1 | Token expiry (1h vs 24h) | Preference | Project-specific config; no external authority determines this |
| 2 | Deletion behaviour (soft vs permanent) | Preference (partially resolved by changelog) | Changelog confirms soft-delete with recovery window exists; SDK-docs is simply stale |
| 3 | Recovery window (30-day vs 14-day) | Preference (resolved by changelog) | Changelog is the timeline authority; current value is 14 days |
| 4 | Rate limit (5 vs 10 per minute) | Preference | Project-specific setting; changelog says "5 attempts per minute" was the v2.2.0 implementation |
| 5 | Email verification | Preference (resolved by changelog) | Changelog explicitly removed this in v2.3.0 |
| 6 | Free-tier project limit (10 vs unlimited) | Preference | Business decision; no external authority |

All contradictions are **preference** — they are internal project decisions. No external documentation can resolve them. However, the changelog provides strong temporal authority for several:

---

### Resolved via changelog (temporal authority):

**#3: Recovery window**
- routes.md says: "30-day recovery window"
- changelog v2.3.0 says: "14-day recovery window (was immediate)"
- **Fix**: update routes.md to "14-day recovery window". Update sdk-docs.md to document soft-delete with 14-day recovery (not "permanent and immediate").

**#5: Email verification**
- routes.md says: "Email verification required before first login"
- changelog v2.3.0 says: "Removed email verification requirement"
- **Fix**: remove the email verification line from routes.md. Remove `auth/email-not-verified` from sdk-docs.md error codes.

**Pagination max (not a numbered contradiction but a stale value):**
- routes.md says: "max 50 per page"
- changelog v2.3.0 says: "Increased pagination max from 50 to 100"
- **Fix**: update routes.md to "max 100 per page".

**Colour field format:**
- sdk-docs.md says: "accepts any CSS color value"
- changelog v2.3.0 says: "Changed to accept only hex codes"
- **Fix**: update sdk-docs.md to "accepts hex colour codes only".

---

### Needs your call:

**#1: Token expiry**
- Option A (routes.md): 3600 seconds (1 hour)
- Option B (sdk-docs.md): 24 hours
- The changelog doesn't mention a change to token expiry. Which is correct?

**#4: Login rate limit**
- Option A (routes.md + changelog v2.2.0): 5 attempts per minute
- Option B (sdk-docs.md): 10 attempts per minute
- The changelog introduced rate limiting at "5 attempts per minute" in v2.2.0. No subsequent change is logged. This strongly suggests 5/min is current and sdk-docs.md is wrong. Confirm?

**#6: Free-tier project limit**
- Option A (routes.md): Max 10 projects per free-tier user
- Option B (sdk-docs.md): Unlimited projects
- The changelog doesn't mention a change. Which is the actual limit?

**Terminology (colour vs color):**
- What is the actual API field name in HTTP request bodies — `colour` or `color`?

---

### Recommendations for overlaps and terminology

For the pagination default (per_page 20 vs 25): routes.md should be the single source of truth for API defaults since it defines the HTTP interface. SDK-docs should match or omit the default and link to the API spec.

For colour/color spelling: pick one. If the HTTP field is `colour`, the SDK should map it internally but document what the API actually accepts.

---

## Step 6

Want me to update the files to resolve these? (Pending your answers to the preference questions above.)
