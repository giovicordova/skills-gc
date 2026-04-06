# Transcript: Authentication Research (Passport.js + JWT in localStorage)

## Task
Evaluate whether Passport.js with local strategy and JWT stored in localStorage is still the recommended approach for authentication, or if better alternatives exist.

## Research Steps

### Step 1: JWT localStorage security risks (web search)
- Query: "JWT localStorage security risks 2025 2026 authentication best practices"
- Key finding: localStorage is widely considered insecure for JWT storage due to XSS vulnerability. The consensus recommendation is HttpOnly cookies or in-memory storage with HttpOnly cookie refresh tokens.

### Step 2: Passport.js alternatives (web search)
- Query: "passport.js alternatives 2025 2026 Node.js authentication"
- Key finding: Better Auth, Auth.js, Auth0, WorkOS, and Firebase Auth are the leading alternatives. Passport.js is still used but has maintenance concerns.

### Step 3: HttpOnly cookie vs localStorage comparison (web search)
- Query: "httponly cookie vs localStorage JWT token security 2025"
- Key finding: HttpOnly cookies with Secure and SameSite flags are the recommended storage mechanism. The hybrid approach (access token in memory, refresh token in HttpOnly cookie) is considered the most secure for SPAs.

### Step 4: Passport.js maintenance status (web search)
- Query: "passport.js maintenance status 2025 2026 still maintained"
- Key finding: Passport.js has 300+ open issues and a long-running GitHub discussion about its future (Issue #748). Maintenance appears limited, though the library remains functional and widely used.

### Step 5: BFF pattern research (web search)
- Query: "BFF pattern backend for frontend authentication SPA 2025 session cookie token"
- Key finding: The BFF (Backend for Frontend) pattern is the emerging industry standard for SPA auth. Tokens never reach the browser; a backend proxy handles all token operations and sets HttpOnly session cookies.

### Step 6: Modern auth libraries (web search)
- Query: "better-auth arctic oslo auth node.js 2025 2026 modern authentication library"
- Key finding: Better Auth is a comprehensive TypeScript-first auth framework with active development. Arctic + Oslo provide lightweight OAuth 2.0 clients. Both are newer, actively maintained alternatives to Passport.js.

## Conclusion
The Passport.js + JWT in localStorage approach has two distinct problems:
1. **localStorage is insecure** -- tokens should be in HttpOnly cookies, in-memory, or handled server-side via BFF pattern
2. **Passport.js has uncertain maintenance** -- newer libraries like Better Auth offer more features with active development

Recommended to either adopt a managed auth service or migrate to a modern library, and in either case move tokens out of localStorage immediately.
