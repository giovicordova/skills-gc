# Passport.js + JWT in localStorage: Still Recommended?

**No. This combination has two separate problems, and both now have better alternatives.**

---

## Problem 1: JWT in localStorage is a known security risk

localStorage is fully accessible to any JavaScript running on your page. If an attacker injects a malicious script (XSS attack), they can read the token and impersonate the user. Unlike cookies, localStorage has zero built-in security controls -- no HttpOnly flag, no Secure flag, no SameSite attribute.

### What to do instead (ranked by security)

| Approach | How it works | Protects against |
|----------|-------------|-----------------|
| **BFF pattern** (best) | A thin backend proxy handles all tokens server-side. The browser only gets an HttpOnly session cookie. No tokens ever reach the frontend. | XSS and CSRF |
| **Memory + HttpOnly cookie** (good) | Short-lived access token lives in JS memory (e.g. React state). Long-lived refresh token in an HttpOnly, Secure, SameSite=Strict cookie. | XSS (tokens aren't in storage); CSRF (with SameSite) |
| **HttpOnly cookie only** (acceptable) | Store the JWT itself in an HttpOnly, Secure, SameSite cookie. Add a CSRF token. | XSS (script can't read the cookie) |

The BFF (Backend for Frontend) pattern is gaining traction as the industry-recommended approach for SPAs. The browser-based app never touches access tokens at all -- the backend proxy handles token exchange and storage, then sets a traditional session cookie. Auth0, Duende, and FusionAuth all now offer BFF support.

---

## Problem 2: Passport.js has maintenance concerns

Passport.js is still widely used (22,000+ GitHub stars), but its maintenance status is uncertain. The GitHub repo has 300+ open issues, many spanning years without responses. A [long-running discussion about the project's future](https://github.com/jaredhanson/passport/issues/748) has been open since 2021. It works, but it's not actively evolving.

### Modern alternatives worth considering

| Library | Best for | Notes |
|---------|---------|-------|
| **[Better Auth](https://better-auth.com/)** | Full-stack TypeScript apps | Framework-agnostic, built-in session management, email verification, password reset, social login. Active development. |
| **[Auth.js](https://authjs.dev/)** (formerly NextAuth) | Next.js / SvelteKit / framework-specific apps | Strong framework integration, active community. |
| **[Arctic](https://arcticjs.dev/) + [Oslo](https://oslo.js.org/)** | Lightweight OAuth 2.0 | Minimal, typed, runtime-agnostic OAuth clients. Good if you want to build your own auth layer without a heavy framework. |
| **Auth0 / WorkOS / Firebase Auth** | Managed auth (don't build it yourself) | Offload auth entirely. Best if you don't want to maintain auth infrastructure. |

---

## Recommended path forward

**If you're building something new:** Use a managed service (Auth0, WorkOS, Firebase Auth) or Better Auth. Don't build auth from scratch unless you have a specific reason to.

**If you're maintaining an existing Passport.js app:** The library still works. Prioritise moving tokens out of localStorage into HttpOnly cookies or the BFF pattern. That's the higher-risk issue.

**If you're a solo dev or small team:** Managed auth services are worth the cost. Auth is one of the easiest things to get subtly wrong, and the consequences of getting it wrong are severe.

---

## Sources

- [Secure JWT Storage: Best Practices -- Syncfusion](https://www.syncfusion.com/blogs/post/secure-jwt-storage-best-practices)
- [JWT Storage 101: How to Keep Your Tokens Secure -- WorkOS](https://workos.com/blog/secure-jwt-storage)
- [Top 5 Authentication Solutions for Node.js Apps in 2026 -- WorkOS](https://workos.com/blog/top-authentication-solutions-node-js-2026)
- [The Backend for Frontend Pattern (BFF) -- Auth0](https://auth0.com/blog/the-backend-for-frontend-pattern-bff/)
- [A Guide to Backend-for-Frontend (BFF) Auth -- FusionAuth](https://fusionauth.io/blog/backend-for-frontend)
- [The Future of Passport.js -- GitHub Issue #748](https://github.com/jaredhanson/passport/issues/748)
- [JWT Authentication Best Practices -- LogRocket](https://blog.logrocket.com/jwt-authentication-best-practices/)
- [JWT Token Storage Security: Moving Beyond localStorage -- Medium](https://medium.com/@jatinjamdagni13/jwt-token-storage-security-moving-beyond-localstorage-to-modern-best-practices-fa5be6397acb)
- [Better Auth](https://better-auth.com/)
- [Arctic v3 Documentation](https://arcticjs.dev/)
- [Stop Using Passport for Node.js Authentication with JWT -- Medium](https://medium.com/@agentwhs/stop-using-passport-for-node-js-authentication-with-jwt-89e8971872b3)
