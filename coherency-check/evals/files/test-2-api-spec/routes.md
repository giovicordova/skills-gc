# API Routes

## Authentication

### POST /auth/login
- Body: `{ email, password }`
- Returns: `{ token, expires_in: 3600 }`
- Rate limit: 5 attempts per minute

### POST /auth/register
- Body: `{ email, password, name }`
- Returns: `{ user, token }`
- Email verification required before first login

## Users

### GET /users/me
- Returns current user profile
- Requires: Bearer token

### PATCH /users/me
- Updates current user profile
- Body: `{ name?, email?, avatar_url? }`
- Returns: updated user object

### DELETE /users/me
- Soft-deletes the user account
- Requires re-authentication (password in body)
- 30-day recovery window

## Projects

### GET /projects
- Lists all projects the user has access to
- Pagination: `?page=1&per_page=20` (max 50 per page)
- Default sort: `created_at desc`

### POST /projects
- Creates a new project
- Body: `{ name, description?, colour? }`
- Colour must be a valid hex code (e.g. `#FF5733`)
- Max 10 projects per free-tier user
