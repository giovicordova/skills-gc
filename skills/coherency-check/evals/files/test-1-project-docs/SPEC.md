# TaskFlow Technical Specification

## Architecture

TaskFlow is a task management platform supporting teams of up to 25 members per organisation. Built on:

- Node.js 20 with Fastify
- PostgreSQL 15
- Redis for caching and pub/sub
- Session-based authentication with 8-hour session duration

## Data Model

### Tasks

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | Primary key |
| title | string | Task title, max 200 chars |
| status | enum | One of: `todo`, `doing`, `review`, `complete` |
| assignee_id | UUID | Foreign key to users |
| workspace_id | UUID | Foreign key to workspaces |
| created_at | timestamp | Auto-set |
| due_date | date | Optional |

### Workspaces

Each workspace supports up to 25 members. Workspace owners can invite members and manage billing.

## API

Base URL: `https://api.taskflow.io/v2`

All endpoints are rate-limited to 60 requests per minute per API key.

Authentication is via API key passed in the `X-API-Key` header.

## Deployment

Deployed to Google Cloud Run with Cloud SQL (PostgreSQL). Infrastructure managed via Pulumi. See `deploy/` for configuration.
