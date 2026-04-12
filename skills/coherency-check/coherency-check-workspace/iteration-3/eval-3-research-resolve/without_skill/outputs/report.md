# Coherency Check — Pulse Project Docs

## Summary

These three files contradict each other on several important points. A new dev following them would hit confusion immediately. Below are the conflicts found, grouped by topic.

---

## Conflicts Found

### 1. Data Fetching Pattern (Critical)

| File | Claim |
|------|-------|
| SETUP.md | "uses `getServerSideProps` in each route to fetch data server-side before rendering" |
| ARCHITECTURE.md | "Pages are React Server Components by default — data fetching happens directly inside `async` component functions, no need for `getServerSideProps` or `getStaticProps`" |

These are mutually exclusive. `getServerSideProps` is a Pages Router pattern; App Router uses Server Components for data fetching. ARCHITECTURE.md is correct for Next.js 14 App Router.

---

### 2. Tailwind CSS v4 Configuration (Critical)

| File | Claim |
|------|-------|
| SETUP.md | "config lives in `tailwind.config.js` at the project root" |
| ARCHITECTURE.md | "configured via the new CSS-based `@theme` directive in `app/globals.css`. No JavaScript config file needed in v4" |
| STYLE-GUIDE.md | "Design tokens defined in the Tailwind config" (implies JS config exists) |

Tailwind v4 removed the JS config file. SETUP.md and STYLE-GUIDE.md describe v3 behaviour; ARCHITECTURE.md describes v4 correctly.

---

### 3. Package Manager (Critical)

| File | Claim |
|------|-------|
| SETUP.md | `pnpm` (install command: `pnpm install`, `pnpm dev`) |
| STYLE-GUIDE.md | `yarn` (install command: `yarn install`, `yarn add`) |

A new dev won't know which to use. Only one lockfile should exist in the repo.

---

### 4. Deployment Platform (Major)

| File | Claim |
|------|-------|
| SETUP.md | Deployed to **AWS Amplify** |
| ARCHITECTURE.md | Deployed to **Vercel** |

These are completely different platforms with different configuration, environment variable setup, and edge runtime support.

---

### 5. API Architecture (Major)

| File | Claim |
|------|-------|
| SETUP.md | "All API routes live under `app/api/`" |
| ARCHITECTURE.md | "No REST API layer — Server Actions replace traditional API routes for mutations" |
| STYLE-GUIDE.md | "API routes under `app/api/` follow REST conventions" with detailed REST patterns |

ARCHITECTURE.md says there are no API routes for mutations, while SETUP.md and STYLE-GUIDE.md describe and prescribe them in detail.

---

### 6. Rate Limiting (Minor)

| File | Claim |
|------|-------|
| SETUP.md | 200 requests/min per user |
| ARCHITECTURE.md | 100 requests/min per user |
| STYLE-GUIDE.md | 200 requests/min per user |

Two say 200, one says 100. Which is correct?

---

### 7. `useEffect` Timing (Minor but dangerous for devs)

| File | Claim |
|------|-------|
| ARCHITECTURE.md | "`useEffect` fires before the browser paints" |
| STYLE-GUIDE.md | "`useEffect` for post-render side effects — it runs after the browser has painted" |

STYLE-GUIDE.md is correct. `useEffect` runs after paint; `useLayoutEffect` runs before paint. ARCHITECTURE.md has this backwards and would mislead developers.

---

## Recommendation

Before sharing with the new dev, resolve each conflict above by picking the single source of truth. The most likely correct versions based on the stated stack (Next.js 14 App Router):

1. **Data fetching** — Server Components, not `getServerSideProps`. Fix SETUP.md.
2. **Tailwind config** — CSS-based `@theme` in v4, no JS config. Fix SETUP.md and STYLE-GUIDE.md.
3. **Package manager** — Pick one and fix the other file.
4. **Deployment** — Pick one and fix the other file.
5. **API routes** — Decide: Server Actions only, or REST routes too? Update all three to match.
6. **Rate limit** — Confirm the actual number and fix the outlier.
7. **useEffect** — Fix ARCHITECTURE.md (it's wrong about timing).
