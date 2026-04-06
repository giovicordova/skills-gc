#!/usr/bin/env bash
# Setup for eval 1: code-session-rich-narrative
# Usage: bash setup-1-code-session.sh <target-dir>
set -euo pipefail
TARGET="${1:?usage: $0 <target-dir>}"
mkdir -p "$TARGET"
cd "$TARGET"

git init -q
git config user.email "test@example.com"
git config user.name "Test User"
git config commit.gpgsign false

mkdir -p src/routes src/middleware tests

# Prior commit 1
cat > src/user.ts <<'EOF'
export interface User { id: string; email: string }
export const userStore = new Map<string, User>()
EOF
git add src/user.ts
git commit -q -m "Add user model

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>"

# Prior commit 2
cat > src/routes/login.ts <<'EOF'
import { userStore } from '../user'
export async function loginHandler(req: any, res: any) {
  const user = userStore.get(req.body.email)
  if (!user) return res.status(401).json({ error: 'invalid' })
  return res.json({ ok: true })
}
EOF
git add src/routes/login.ts
git commit -q -m "Wire up login route

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>"

# Prior commit 3
cat > src/routes/auth.ts <<'EOF'
import jwt from 'jsonwebtoken'
const SECRET = process.env.JWT_SECRET || 'dev-secret'
export async function loginHandler(req: any, res: any) {
  const token = jwt.sign({ sub: req.body.email }, SECRET, { expiresIn: '15m' })
  return res.json({ accessToken: token })
}
EOF
git add src/routes/auth.ts
git commit -q -m "Issue access tokens on login

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>"

# Prior commit 4
cat > tests/auth.test.ts <<'EOF'
import { describe, it, expect } from 'vitest'
describe('auth', () => {
  it('issues an access token on login', () => {
    expect(true).toBe(true)
  })
})
EOF
git add tests/auth.test.ts
git commit -q -m "Write auth integration tests

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>"

# Now simulate end-of-session state — three modified/new files
cat > src/middleware/jwt.ts <<'EOF'
// JWT validation extracted from routes/auth.ts so /refresh can reuse it
// without creating a circular import via routes/auth.ts -> lib/db -> jwt
import jwt from 'jsonwebtoken'
const SECRET = process.env.JWT_SECRET || 'dev-secret'

export async function jwtVerify(token: string) {
  try {
    return jwt.verify(token, SECRET) as { sub: string }
  } catch {
    return null
  }
}

export function jwtSign(payload: { sub: string }) {
  return jwt.sign(payload, SECRET, { expiresIn: '15m' })
}

// TODO: check revocation list before accepting refresh tokens
EOF

cat > src/routes/auth.ts <<'EOF'
import { jwtVerify, jwtSign } from '../middleware/jwt'

export async function loginHandler(req: any, res: any) {
  const token = jwtSign({ sub: req.body.email })
  return res.json({ accessToken: token })
}

export async function refreshHandler(req: any, res: any) {
  const refreshToken = req.body.refreshToken
  if (!refreshToken) return res.status(400).json({ error: 'missing refresh token' })
  const payload = await jwtVerify(refreshToken)
  if (!payload) return res.status(401).json({ error: 'invalid refresh token' })
  const newAccessToken = jwtSign({ sub: payload.sub })
  return res.json({ accessToken: newAccessToken })
}
EOF

cat > README.md <<'EOF'
# Project

## API
- POST /api/login — exchange credentials for an access token
- POST /api/refresh — exchange a refresh token for a new access token (15m TTL)
EOF

echo "READY: $TARGET"
