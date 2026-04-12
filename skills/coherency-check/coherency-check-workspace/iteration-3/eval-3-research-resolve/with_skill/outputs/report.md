## Coherency Check: Pulse project docs (SETUP.md, ARCHITECTURE.md, STYLE-GUIDE.md)

**3 files checked — 6 contradictions, 1 overlap, 0 terminology drift, 1 stale reference found.**

### Contradictions

| # | Issue | File A | File B | Severity |
|---|-------|--------|--------|----------|
| 1 | Data fetching method in App Router | SETUP.md: "uses `getServerSideProps` in each route to fetch data server-side" | ARCHITECTURE.md: "data fetching happens directly inside `async` component functions, no need for `getServerSideProps`" | High |
| 2 | Tailwind CSS v4 configuration method | SETUP.md: "config lives in `tailwind.config.js` at the project root" | ARCHITECTURE.md: "configured via the new CSS-based `@theme` directive in `app/globals.css`. No JavaScript config file needed in v4." | High |
| 3 | When `useEffect` fires | ARCHITECTURE.md: "`useEffect` fires before the browser paints" | STYLE-GUIDE.md: "`useEffect` for post-render side effects — it runs after the browser has painted" | High |
| 4 | Package manager | SETUP.md: "pnpm (package manager)", `pnpm install` | STYLE-GUIDE.md: "Use `yarn` for all dependency management", `yarn install` | Medium |
| 5 | Deployment target | SETUP.md: "Deployed to AWS Amplify" | ARCHITECTURE.md: "Deployed to Vercel" | High |
| 6 | Rate limit value | SETUP.md + STYLE-GUIDE.md: "200 requests per minute per user" | ARCHITECTURE.md: "100 requests per minute per user" | Medium |

### Overlapping Definitions

- **API design approach**: SETUP.md and STYLE-GUIDE.md both describe REST API routes under `app/api/` with conventions. ARCHITECTURE.md contradicts both by stating "No REST API layer — Server Actions replace traditional API routes for mutations." This is both an overlap (two files define the API pattern) and a contradiction (a third says no API routes exist for mutations).

### Stale References

- **SETUP.md references `getServerSideProps`** — this function does not exist in the Next.js App Router. It belongs to the Pages Router. If the project uses App Router (as both SETUP.md and ARCHITECTURE.md state), then SETUP.md's description of data fetching is referencing a deprecated/unavailable pattern.

---

## Step 5: Classification and Resolution

### Resolved via official sources:

**#1: Data fetching in Next.js 14 App Router — `getServerSideProps` vs async Server Components**
- SETUP.md says: "uses `getServerSideProps` in each route to fetch data server-side"
- ARCHITECTURE.md says: "data fetching happens directly inside `async` component functions, no need for `getServerSideProps`"
- **Source**: The Next.js App Router does NOT support `getServerSideProps`. That function is exclusive to the Pages Router. In the App Router, data fetching happens directly inside async Server Components using `fetch()` or database queries. The migration guide explicitly states these functions are "replaced with a simpler API built on top of fetch() and async React Server Components." — [Next.js App Router Migration Guide](https://nextjs.org/docs/app/building-your-application/upgrading/app-router-migration)
- **Fix**: Update SETUP.md to remove all references to `getServerSideProps`. Replace with a description of async Server Components for data fetching.

**#2: Tailwind CSS v4 configuration — `tailwind.config.js` vs CSS-based `@theme`**
- SETUP.md says: "config lives in `tailwind.config.js` at the project root"
- ARCHITECTURE.md says: "configured via the new CSS-based `@theme` directive in `app/globals.css`. No JavaScript config file needed in v4."
- **Source**: Tailwind CSS v4 moved to a CSS-first configuration model. The `tailwind.config.js` file is no longer the primary config mechanism. Customisations are defined directly in CSS using the `@theme` directive. The JS config file is only needed for legacy compatibility or advanced plugin use cases. — [Tailwind CSS v4.0 announcement](https://tailwindcss.com/blog/tailwindcss-v4) | [Theme variables docs](https://tailwindcss.com/docs/theme)
- **Fix**: Update SETUP.md to reference `@theme` in `app/globals.css` instead of `tailwind.config.js`.

**#3: When `useEffect` fires relative to browser paint**
- ARCHITECTURE.md says: "`useEffect` fires before the browser paints"
- STYLE-GUIDE.md says: "runs after the browser has painted, so it won't block visual updates"
- **Source**: The official React documentation states that for non-interaction-triggered effects, "React will generally let the browser paint the updated screen first before running your Effect." The default behaviour is that `useEffect` runs AFTER paint. `useLayoutEffect` is what runs before paint. — [React useEffect docs](https://react.dev/reference/react/useEffect)
- **Fix**: Update ARCHITECTURE.md to correct the `useEffect` description. It should say `useEffect` fires after paint (not before). The STYLE-GUIDE.md is correct.

---

### Needs your call:

**#4: Package manager — pnpm vs yarn**
- Option A (SETUP.md): pnpm — `pnpm install`, `pnpm dev`
- Option B (STYLE-GUIDE.md): yarn — `yarn install`, `yarn add`
- Context: These are mutually exclusive choices. Which one does the project actually use?

**#5: Deployment target — AWS Amplify vs Vercel**
- Option A (SETUP.md): AWS Amplify, auto-deploy on push to `main`
- Option B (ARCHITECTURE.md): Vercel, preview deployments on PRs, production on `main` merge, edge middleware for auth/geo-routing
- Context: ARCHITECTURE.md's description is more detailed and mentions Vercel-specific features (edge middleware, preview deploys). If those features are in use, Vercel is the actual target and SETUP.md is stale. But this is your call.

**#6: Rate limit — 200 vs 100 requests per minute**
- Option A (SETUP.md + STYLE-GUIDE.md): 200 requests/min/user
- Option B (ARCHITECTURE.md): 100 requests/min/user
- Context: Two files agree on 200, one says 100. The majority isn't necessarily correct — ARCHITECTURE.md may reflect a deliberate tightening. Which value is current?

---

Sources:
- [Next.js App Router Migration Guide](https://nextjs.org/docs/app/building-your-application/upgrading/app-router-migration)
- [Next.js getServerSideProps (Pages Router only)](https://nextjs.org/docs/pages/building-your-application/data-fetching/get-server-side-props)
- [Tailwind CSS v4.0 announcement](https://tailwindcss.com/blog/tailwindcss-v4)
- [Tailwind CSS v4 Theme variables](https://tailwindcss.com/docs/theme)
- [React useEffect official docs](https://react.dev/reference/react/useEffect)
- [React useLayoutEffect official docs](https://react.dev/reference/react/useLayoutEffect)
