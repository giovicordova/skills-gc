#!/usr/bin/env bash
# Setup for eval 3: investigation-empty-commit
# Usage: bash setup-3-investigation.sh <target-dir>
set -euo pipefail
TARGET="${1:?usage: $0 <target-dir>}"
mkdir -p "$TARGET"
cd "$TARGET"

git init -q
git config user.email "test@example.com"
git config user.name "Test User"
git config commit.gpgsign false

mkdir -p src/middleware src/lib

# Prior commit 1
cat > src/lib/session-cache.ts <<'EOF'
export const sessionCache = new Map<string, any>()
export function getSession(id: string) { return sessionCache.get(id) }
export function setSession(id: string, value: any) { sessionCache.set(id, value) }
EOF
git add src/lib/session-cache.ts
git commit -q -m "Add session cache"

# Prior commit 2 — this is the version that introduced the bug
cat > src/middleware/auth.ts <<'EOF'
import { db } from '../lib/db'

export async function validateSession(req: any, res: any, next: any) {
  const sessionId = req.cookies?.sid
  if (!sessionId) return res.status(401).json({ error: 'unauth' })
  // BUG: should check session-cache first, but rewrites dropped that step
  const session = await db.sessions.findById(sessionId)
  if (!session) return res.status(401).json({ error: 'unauth' })
  req.session = session
  next()
}
EOF
mkdir -p src/lib
cat > src/lib/db.ts <<'EOF'
export const db = { sessions: { findById: async (_id: string) => ({ id: _id, userId: 'u1' }) } }
EOF
git add src/middleware/auth.ts src/lib/db.ts
git commit -q -m "Wire auth middleware"

# Prior commit 3
cat > src/lib/datadog.ts <<'EOF'
export const ddog = { gauge: (_name: string, _value: number) => {} }
EOF
git add src/lib/datadog.ts
git commit -q -m "Add datadog monitoring"

# Prior commit 4
echo "v1.4.2" > VERSION
git add VERSION
git commit -q -m "Deploy v1.4.2"

# IMPORTANT: working tree is clean at end of setup
echo "READY: $TARGET"
