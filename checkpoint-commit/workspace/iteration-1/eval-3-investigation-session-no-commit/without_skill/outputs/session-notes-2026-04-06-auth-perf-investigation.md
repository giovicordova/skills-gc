# Session checkpoint — 2026-04-06

## Status
Investigation only. No code changed. Root cause confirmed, fix not started.

## Problem
API response times spiked after Monday's deploy.

## Root cause
`validateSession()` in `src/middleware/auth.ts` (~line 23) runs a DB query on
every request. It should check the session cache first and fall back to the DB
only on cache miss. Every authenticated request is currently paying full DB
round-trip latency, which is why p50/p95 both climbed post-deploy.

Call path:
  authMiddleware -> validateSession(token) -> loadSessionFromDB(token)

The cache lookup step that should sit between `validateSession` and
`loadSessionFromDB` is missing entirely.

## Evidence
- Traced through `src/middleware/auth.ts`.
- `validateSession()` has no cache reference at all.
- Every request to any authMiddleware-protected route hits the DB.

## Not done yet
- No fix written.
- No cache client wired in.
- No tests.
- No rollback or hotfix shipped.

## Pick up tomorrow
1. Decide cache layer (existing Redis client? in-memory LRU for now?).
2. Add `getSessionFromCache(token)` + `setSessionInCache(session)`.
3. In `validateSession`: cache.get -> on miss, DB -> on hit, return; write-through on DB hit.
4. Respect `expiresAt` in cache TTL.
5. Add a unit test that asserts DB is not called on cache hit.
6. Deploy behind a feature flag if one exists; otherwise watch p95 after rollout.

## Open questions
- Is there already a Redis/Memcached client in the project to reuse?
- What's the acceptable staleness for a cached session (seconds vs minutes)?
- Should invalidation happen on logout, or rely on TTL?
