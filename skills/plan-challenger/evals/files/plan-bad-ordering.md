# Plan: Add User Authentication to Express API

## Context
Existing Express.js REST API with 12 endpoints, PostgreSQL database via Prisma ORM, deployed on Railway. Currently no auth — all endpoints are public. Need to add JWT authentication with email/password signup and login. The API serves a React frontend.

## Steps

### Step 1: Create User Model
- Add User model to Prisma schema with fields: id, email, passwordHash, name, createdAt, updatedAt
- Run prisma migrate to create the table
- Add unique constraint on email

### Step 2: Build Registration Endpoint
- POST /api/auth/register
- Accept email, password, name
- Hash password with bcrypt
- Store in database
- Return user object (without password)

### Step 3: Build Login Endpoint
- POST /api/auth/login
- Accept email, password
- Verify password with bcrypt
- Generate JWT token with 24h expiry
- Return token and user object

### Step 4: Protect All Existing Endpoints
- Create auth middleware that extracts JWT from Authorization header
- Verify token and attach user to request
- Apply middleware to all 12 existing endpoints
- Update all endpoint handlers to use req.user

### Step 5: Update Frontend
- Add login/register pages to React app
- Store JWT in localStorage
- Add token to all API requests via axios interceptor
- Add protected route wrapper component
- Handle token expiry with redirect to login

### Step 6: Add Password Reset
- Create PasswordReset model in Prisma
- POST /api/auth/forgot-password — generate reset token, send email
- POST /api/auth/reset-password — verify token, update password
- Set up email service (Resend or similar)

### Step 7: Deploy
- Push to Railway
- Run database migration in production
- Update environment variables with JWT_SECRET

### Step 8: Add Rate Limiting
- Install express-rate-limit
- Apply to auth endpoints (login, register, forgot-password)
- Configure: 5 attempts per 15 minutes for login

### Step 9: Add Input Validation
- Install zod
- Create validation schemas for all auth endpoints
- Add validation middleware

### Step 10: Write Tests
- Unit tests for auth middleware
- Integration tests for register, login, password reset
- Test protected endpoints return 401 without token
