## Coherency Check: TaskFlow API Spec, SDK Docs, and Changelog

**3 files checked -- 7 contradictions, 1 overlap, 1 terminology drift, 1 stale reference found.**

---

### Contradictions

| # | Issue | File A | File B | Severity |
|---|-------|--------|--------|----------|
| 1 | Token expiry duration | routes.md: Authentication says `expires_in: 3600` (1 hour) | sdk-docs.md: Authentication says "Token is valid for 24 hours" | High |
| 2 | Account deletion behaviour: soft-delete with recovery vs permanent/immediate | routes.md: DELETE /users/me says "Soft-deletes the user account" with "30-day recovery window" | sdk-docs.md: Users section says "Delete account -- permanent and immediate, cannot be undone" | High |
| 3 | Account deletion recovery window duration | routes.md: DELETE /users/me says "30-day recovery window" | changelog.md: v2.3.0 says "Account deletion now has a 14-day recovery window (was immediate)" | High |
| 4 | Login rate limit threshold | routes.md: POST /auth/login says "5 attempts per minute" | sdk-docs.md: Error Handling says `auth/rate-limited` is "max 10 per minute" | High |
| 5 | Max items per page (pagination) | routes.md: GET /projects says "max 50 per page" | sdk-docs.md: Projects section says "Max 100 per page" | Medium |
| 6 | Free-tier project limit | routes.md: POST /projects says "Max 10 projects per free-tier user" | sdk-docs.md: Projects section says "Free tier: unlimited projects" | High |
| 7 | Colour/color field validation | routes.md: POST /projects says "Colour must be a valid hex code" | sdk-docs.md: Projects section says "accepts any CSS color value" | Medium |

#### Temporal resolution using the changelog

The changelog (v2.3.0, 2026-03-15) provides a timeline that resolves or clarifies several of these contradictions:

- **Contradiction #2 (deletion behaviour):** The changelog v2.2.0 introduced soft-delete with a 30-day recovery window. Then v2.3.0 changed the recovery window to 14 days (and notes it "was immediate," referring to the state before v2.2.0). This means: **14-day soft-delete is current (v2.3.0)**. routes.md is stale (still shows 30 days from v2.2.0). sdk-docs.md is stale from before v2.2.0 (still says permanent/immediate).
- **Contradiction #5 (pagination max):** The changelog v2.3.0 says "Increased pagination max from 50 to 100 items per page." This means **100 is current**. routes.md is stale (still says 50). sdk-docs.md is correct.
- **Contradiction #7 (colour field):** The changelog v2.3.0 says "Changed project colour field to accept only hex codes (was previously accepting any CSS colour value)." This means **hex-only is current**. routes.md is correct. sdk-docs.md is stale (still says any CSS color value).

The following contradictions have no changelog entry and remain ambiguous:

- **Contradiction #1 (token expiry):** No changelog entry. 1 hour vs 24 hours is unresolved.
- **Contradiction #4 (rate limit):** The changelog v2.2.0 says "Added rate limiting to login endpoint (5 attempts per minute)." This confirms **5 per minute is current**. sdk-docs.md is wrong (says 10).
- **Contradiction #6 (free-tier project limit):** No changelog entry. 10 vs unlimited is unresolved.

---

### Overlapping Definitions

**Email verification requirement:**
- routes.md (POST /auth/register): "Email verification required before first login"
- changelog.md (v2.3.0, Breaking Changes): "Removed email verification requirement for new accounts. Users can now log in immediately after registration."

The changelog explicitly removed this requirement. routes.md has not been updated to reflect v2.3.0 and still states verification is required. sdk-docs.md does not mention verification in the registration flow but does list `auth/email-not-verified` as an error code, which is now stale.

---

### Terminology Drift

**colour vs color:**
- routes.md uses British English: "colour" (field name and description)
- sdk-docs.md uses American English: "color" (field name in code and comment)
- changelog.md uses British English: "colour"

If the API field is literally named `colour` in requests/responses, then sdk-docs.md showing `color` as the parameter name would cause SDK users to send the wrong field name. If this is just a documentation language choice and the actual field name is consistent, the risk is lower but still confusing.

---

### Stale References

**`auth/email-not-verified` error code (sdk-docs.md, Error Handling section):**
The changelog v2.3.0 removed the email verification requirement entirely. The SDK docs still list `auth/email-not-verified` as a common error code. This error code is either dead code or, at minimum, should no longer be documented as a "common" error.

---

## Resolution

There are 7 contradictions to resolve. I'll walk through each one -- tell me which version should be the source of truth, or if you'd like a different value entirely.

**Contradiction #1: Token expiry duration**
- **Option A** (routes.md): `expires_in: 3600` (1 hour)
- **Option B** (sdk-docs.md): "Token is valid for 24 hours"

No changelog entry covers this, so neither file has a clear temporal advantage. The API spec (routes.md) is typically more authoritative since it defines the actual response payload. Want to go with 1 hour?

**Contradiction #2: Account deletion behaviour**
- **Option A** (routes.md): Soft-delete with 30-day recovery window
- **Option B** (sdk-docs.md): Permanent and immediate
- **Option C** (changelog.md v2.3.0): Soft-delete with 14-day recovery window

The changelog is the most recent authority. **14-day soft-delete is current (v2.3.0).** Both routes.md and sdk-docs.md need updating. Shall I align them to 14-day soft-delete?

**Contradiction #3: Recovery window duration**
This is part of #2. The changelog v2.3.0 sets 14 days as current. routes.md still says 30 days. This resolves together with #2.

**Contradiction #4: Login rate limit**
- **Option A** (routes.md + changelog v2.2.0): 5 attempts per minute
- **Option B** (sdk-docs.md): 10 attempts per minute

The changelog confirms 5 per minute was the value when rate limiting was introduced, and no subsequent entry changed it. **5 per minute is current.** sdk-docs.md needs updating.

**Contradiction #5: Pagination max per page**
- **Option A** (routes.md): max 50 per page
- **Option B** (sdk-docs.md + changelog v2.3.0): max 100 per page

The changelog explicitly increased this to 100 in v2.3.0. **100 is current.** routes.md needs updating.

**Contradiction #6: Free-tier project limit**
- **Option A** (routes.md): Max 10 projects per free-tier user
- **Option B** (sdk-docs.md): Unlimited projects

No changelog entry. This is a business-critical discrepancy -- it affects what users are told they can do. Which is correct?

**Contradiction #7: Colour field validation**
- **Option A** (routes.md + changelog v2.3.0): Hex codes only
- **Option B** (sdk-docs.md): Any CSS color value

The changelog explicitly narrowed this to hex-only in v2.3.0. **Hex-only is current.** sdk-docs.md needs updating.

---

For the **overlapping definition** (email verification), the changelog is authoritative: verification was removed in v2.3.0. I'd recommend removing the requirement from routes.md and removing the `auth/email-not-verified` error code from sdk-docs.md (or at minimum demoting it from "common" errors). Want me to make those updates?

For the **terminology drift** (colour/color), this needs a decision: is the actual API field name `colour` or `color`? Once decided, all three files should use the same field name in code/API contexts (prose language can follow each file's convention, but field names must be exact).
