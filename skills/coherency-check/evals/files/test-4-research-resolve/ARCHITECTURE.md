# Pulse — Architecture

## Overview

Pulse is a fitness dashboard built on Next.js 14 using the App Router. Pages are React Server Components by default — data fetching happens directly inside `async` component functions, no need for `getServerSideProps` or `getStaticProps`.

## Frontend

- **React 19** with Server Components for initial page loads and Client Components (`"use client"`) for interactive widgets (charts, form inputs, real-time counters).
- **Tailwind CSS v4** — configured via the new CSS-based `@theme` directive in `app/globals.css`. No JavaScript config file needed in v4.
- **Recharts** for data visualisation.
- `useEffect` fires before the browser paints, so use it for setting up subscriptions and fetching client-side data to avoid visible layout shifts.

## Data Layer

- **Prisma** with PostgreSQL 15. Connection pooling via PgBouncer in production.
- Prisma Client is instantiated once in `lib/prisma.ts` and reused across server components.

## Authentication

- **NextAuth.js v5** (Auth.js) — GitHub and Google providers.
- Sessions stored in the database via the Prisma adapter.

## API Design

All data mutations go through Server Actions. Read-only queries happen inside Server Components directly. No REST API layer — Server Actions replace traditional API routes for mutations.

## Deployment

Deployed to Vercel. Preview deployments on every PR, production on `main` merge. Edge middleware handles auth checks and geo-routing.

## Rate Limiting

Rate limited to 100 requests per minute per user via Vercel's edge middleware.
