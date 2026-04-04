**What's there** — Passport.js with passport-local for username/password authentication, passport-jwt for protecting routes, and JWT stored in localStorage on the client. This is the classic Node.js auth stack that dominated from roughly 2016-2022. No code exists in this repo to audit, so this is a general architecture review.

**What's worth knowing** — Storing JWT in localStorage is now widely considered insecure. Any XSS vulnerability gives an attacker full access to the token via JavaScript. The current consensus (backed by OWASP and repeated across security literature through 2025-2026) is: store short-lived access tokens in memory (JS variable/React state) and long-lived refresh tokens in httpOnly, Secure, SameSite cookies. passport-jwt already supports cookie extraction via a custom extractor function, so switching storage doesn't require changing your auth library. Separately, Passport.js itself is showing its age — the plugin ecosystem is large but the core hasn't had significant architectural updates. Newer alternatives like Better Auth offer a more batteries-included approach with built-in middleware, while Auth.js is strong if you're in the Next.js ecosystem. Lucia was popular but has been archived by its maintainer.

**Recommendations** (ordered by impact):

1. **Move JWT out of localStorage immediately.** Store the access token in memory and the refresh token in an httpOnly cookie. This is the single highest-impact security change. passport-jwt's custom cookie extractor makes this straightforward — the docs show the exact pattern.

2. **Keep Passport.js if it's working.** It's not the shiniest tool anymore, but it's stable, well-understood, and has the largest strategy ecosystem in Node.js. Swapping it out purely for novelty isn't worth the effort. If you're starting fresh on a new project, Better Auth is worth evaluating.

3. **Add a refresh token flow.** Short-lived access tokens (5-15 min) plus a refresh endpoint. When the page loads and the in-memory token is gone, the app silently hits the refresh endpoint — the browser sends the httpOnly cookie automatically, and you get a new access token. This is the standard pattern now.

4. **If you must use localStorage** (e.g., cross-domain requirements), keep tokens very short-lived, enforce strict Content Security Policy headers, and sanitise all inputs. But treat this as a fallback, not the default.

Sources:
- [passport-jwt documentation](https://www.passportjs.org/packages/passport-jwt/)
- [JWT Storage: Cookies vs LocalStorage](https://stackinsight.dev/blog/jwt-storage-cookies-vs-localstorage-which-is-right-for-your-app/)
- [LocalStorage vs Cookies security guide](https://www.cyberchief.ai/2023/05/secure-jwt-token-storage.html)
- [Node.js Authentication: Lucia to Better Auth](https://www.nodejs-security.com/blog/nodejs-authentication-migration-from-lucia-to-better-auth)
- [Stop using Passport for JWT authentication](https://medium.com/@agentwhs/stop-using-passport-for-node-js-authentication-with-jwt-89e8971872b3)
- [React JWT Storage Guide](https://cybersierra.co/blog/react-jwt-storage-guide/)
