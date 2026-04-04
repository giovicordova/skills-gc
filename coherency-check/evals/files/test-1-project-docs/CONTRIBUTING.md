# Contributing to TaskFlow

## Setup

1. Install Node.js 18+
2. Clone the repo and run `npm install`
3. Start PostgreSQL locally (or use `docker-compose up db`)
4. Copy `.env.example` to `.env` and fill in your database credentials
5. Run `npm run dev` to start the development server on port 8080

## Task Statuses

When working on tasks in the codebase, note that tasks follow this lifecycle:

`open` → `in_progress` → `done`

There is no review step — we removed it in v2.1 to simplify the workflow.

## Rate Limiting

The API enforces a rate limit of 100 requests per minute per user, using a sliding window algorithm backed by Redis.

## Deployment

We deploy to AWS ECS. The deployment pipeline is managed through GitHub Actions — see `.github/workflows/deploy.yml`.

Infrastructure is defined in Terraform configs under `infrastructure/`.
