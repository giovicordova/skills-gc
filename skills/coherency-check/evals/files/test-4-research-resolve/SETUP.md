# Pulse — Developer Setup

A fitness tracking dashboard built with Next.js and React.

## Prerequisites

- Node.js 20+
- pnpm (package manager)
- PostgreSQL 15

## Stack

- **Next.js 14 App Router** — uses `getServerSideProps` in each route to fetch data server-side before rendering. Every page component exports a `getServerSideProps` function that returns props.
- **Tailwind CSS v4** — config lives in `tailwind.config.js` at the project root. Add custom colours and spacing there.
- **Prisma** — ORM for PostgreSQL. Schema at `prisma/schema.prisma`.
- **NextAuth.js** — authentication via GitHub and Google OAuth.

## Running locally

```bash
pnpm install
pnpm dev      # starts on port 3000
```

## Deployment

Deployed to AWS Amplify. Push to `main` triggers auto-deploy.

## API Routes

All API routes live under `app/api/`. Authentication is handled via middleware that checks the session cookie. Rate limited to 200 requests per minute per user.
