## Coherency Check: TaskFlow API Spec / SDK Docs / Changelog

**3 files checked -- 7 contradictions, 1 overlap, 1 terminology drift, 1 stale reference found.**

Files:
- `routes.md` (API route specification)
- `sdk-docs.md` (JavaScript SDK documentation)
- `changelog.md` (release changelog)

---

### Contradictions

| # | Issue | File A | File B | Severity |
|---|-------|--------|--------|----------|
| 1 | Token expiry duration | routes.md: `POST /auth/login` returns `"expires_in: 3600"` (1 hour) | sdk-docs.md: Authentication section says `"Token is valid for 24 hours"` | High |
| 2 | Account deletion behaviour | routes.md: `DELETE /users/me` says `"Soft-deletes the user account"` with `"30-day recovery window"` | sdk-docs.md: `users.delete()` says `"permanent and immediate, cannot be undone"` | High |
| 3 | Account deletion recovery window duration | routes.md: `DELETE /users/me` says `"30-day recovery window"` | changelog.md: v2.3.0 says `"Account deletion now has a 14-day recovery window (was immediate)"` | High |
| 4 | Pagination max per page | routes.md: `GET /projects` says `"max 50 per page"` | sdk-docs.md: `projects.list()` says `"Max 100 per page"` | Medium |
| 5 | Pagination max per page (changelog alignment) | routes.md: `GET /projects` says `"max 50 per page"` | changelog.md: v2.3.0 says `"Increased pagination max from 50 to 100 items per page"` | Medium |
| 6 | Login rate limit | routes.md: `POST /auth/login` says `"5 attempts per minute"` | sdk-docs.md: Error codes section says `"max 10 per minute"` | Medium |
| 7 | Project colour field accepted values | routes.md: `POST /projects` says `"Colour must be a valid hex code"` | sdk-docs.md: `projects.create()` says `"accepts any CSS color value"` | Medium |

**Detail on each contradiction:**

**#1 -- Token expiry.** The API spec says tokens last 1 hour (3600 seconds). The SDK docs tell developers tokens last 24 hours. One of these is wrong, and whichever it is, developers will either cache tokens too long (security risk) or refresh them too often (unnecessary friction).

**#2 -- Deletion behaviour: soft vs. permanent.** The API spec explicitly states soft-delete with a recovery window. The SDK docs tell users deletion is "permanent and immediate, cannot be undone." These are flatly incompatible -- a developer reading the SDK docs would never expect recovery to be possible.

**#3 -- Recovery window length: 30 days vs. 14 days.** The API spec says 30 days. The changelog v2.3.0 says 14 days (and notes v2.2.0 introduced a 30-day window). The API spec appears to reflect the v2.2.0 state and was not updated when v2.3.0 shortened the window to 14 days.

**#4 and #5 -- Pagination max.** Three-way conflict. The API spec says 50. The SDK docs say 100. The changelog says the max was increased from 50 to 100 in v2.3.0. The API spec was not updated to reflect the v2.3.0 change; the SDK docs already reflect the new value.

**#6 -- Rate limit.** The API spec says 5 attempts per minute. The SDK error codes section says 10 per minute. The changelog v2.2.0 introduced rate limiting at "5 attempts per minute," aligning with the API spec. The SDK docs appear to have the wrong number.

**#7 -- Colour field values.** The API spec restricts the colour field to hex codes. The SDK docs say "accepts any CSS color value." The changelog v2.3.0 explicitly states the field was changed to "accept only hex codes (was previously accepting any CSS colour value)." The SDK docs were not updated to reflect this v2.3.0 breaking change.

---

### Overlapping Definitions

**Email verification requirement.** Three files address whether email verification is needed before login, each saying something different:
- `routes.md` (`POST /auth/register`): "Email verification required before first login"
- `sdk-docs.md` (Error codes): lists `auth/email-not-verified` as an error code, implying verification exists
- `changelog.md` (v2.3.0 Breaking Changes): "Removed email verification requirement for new accounts. Users can now log in immediately after registration."

The changelog removes the requirement, but the API spec still mandates it and the SDK docs still list the corresponding error code. Both `routes.md` and `sdk-docs.md` are stale on this point.

---

### Terminology Drift

**"colour" vs. "color".** The API spec (`routes.md`) uses British English spelling (`colour`), while the SDK docs (`sdk-docs.md`) use American English (`color`). This is a field name discrepancy -- if the actual JSON field in the API is `colour`, then the SDK code sample showing `color` would fail; if the field is `color`, the API spec is misleading. Either way, one needs to match the other.

---

### Stale References

**`perPage: 25` default in SDK docs.** The SDK docs show `client.projects.list({ page: 1, perPage: 25 })` as an example call. The API spec documents the default as `per_page=20`. It is unclear whether the SDK changed the default, but the discrepancy suggests the SDK example may be using a non-default value without calling it out, or the default was changed and the API spec was not updated.

---

## Resolution

There are 7 contradictions to resolve. I'll walk through each one -- tell me which version should be the source of truth, or if you'd like a different value entirely.

**Contradiction #1: Token expiry**
- **Option A** (routes.md): 3600 seconds (1 hour)
- **Option B** (sdk-docs.md): 24 hours

The API spec is typically authoritative for actual server behaviour. If the server returns `expires_in: 3600`, the SDK docs are simply wrong.

Which should we go with -- A, B, or something else?

**Contradiction #2: Deletion behaviour (soft-delete vs. permanent)**
- **Option A** (routes.md): Soft-delete with a recovery window
- **Option B** (sdk-docs.md): Permanent and immediate, cannot be undone

The changelog confirms soft-delete was added in v2.2.0 and the recovery window was adjusted in v2.3.0. The SDK docs appear to have never been updated.

Which should we go with -- A, B, or something else?

**Contradiction #3: Recovery window duration**
- **Option A** (routes.md): 30-day recovery window
- **Option B** (changelog.md): 14-day recovery window (changed in v2.3.0)

The changelog is the most recent authority here. If v2.3.0 shortened it to 14 days, the API spec needs updating from 30 to 14.

Which should we go with -- A, B, or something else?

**Contradiction #4/5: Pagination max per page**
- **Option A** (routes.md): max 50 per page
- **Option B** (sdk-docs.md + changelog.md): max 100 per page (changed in v2.3.0)

The changelog documents this as a v2.3.0 change. The API spec was not updated.

Which should we go with -- A, B, or something else?

**Contradiction #6: Login rate limit**
- **Option A** (routes.md + changelog.md): 5 attempts per minute
- **Option B** (sdk-docs.md): 10 attempts per minute

Two out of three files agree on 5. The SDK docs appear incorrect.

Which should we go with -- A, B, or something else?

**Contradiction #7: Colour field accepted values**
- **Option A** (routes.md + changelog.md): Hex codes only (v2.3.0 breaking change)
- **Option B** (sdk-docs.md): Any CSS colour value

The changelog explicitly marks this as a breaking change in v2.3.0. The SDK docs were not updated.

Which should we go with -- A, B, or something else?

---

For the **overlapping definition** (email verification), the changelog v2.3.0 removed the requirement. I'd recommend treating the changelog as authoritative and updating both `routes.md` (remove the verification line) and `sdk-docs.md` (remove the `auth/email-not-verified` error code). Want me to consolidate?

For the **terminology drift** (colour/color), the JSON field name in the actual API needs to be the single source of truth. Whichever spelling the server accepts, both docs should use that exact string. Which spelling does the API actually use?
