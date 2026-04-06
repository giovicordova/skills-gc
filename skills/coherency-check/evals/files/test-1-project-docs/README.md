# TaskFlow

A lightweight task management API for small teams (up to 10 users per workspace).

## Stack

- Node.js 18 with Express
- PostgreSQL 14 for persistence
- Redis for session caching
- JWT authentication with 24-hour token expiry

## Getting Started

1. Clone the repo
2. Copy `.env.example` to `.env`
3. Run `docker-compose up` to start the database
4. Run `npm start` to launch the server on port 3000

## API Overview

All endpoints require authentication via Bearer token. Rate limited to 100 requests per minute per user.

Tasks have four statuses: `open`, `in_progress`, `review`, `done`.

## Deployment

Deploy to AWS using the included Terraform configs. The app runs on ECS Fargate behind an ALB. See `infrastructure/` for details.
