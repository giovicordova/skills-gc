#!/usr/bin/env bash
# Setup for eval 5: mixed-code-and-research
# Usage: bash setup-5-mixed.sh <target-dir>
set -euo pipefail
TARGET="${1:?usage: $0 <target-dir>}"
mkdir -p "$TARGET"
cd "$TARGET"

git init -q
git config user.email "test@example.com"
git config user.name "Test User"
git config commit.gpgsign false

mkdir -p src/api

# Prior commit 1
cat > src/api/openapi.json <<'EOF'
{ "openapi": "3.0.0", "info": { "title": "App API", "version": "0.1.0" } }
EOF
git add src/api/openapi.json
git commit -q -m "Add OpenAPI client scaffolding"

# Prior commit 2
cat > src/api/health.ts <<'EOF'
export function healthHandler(_req: any, res: any) { res.json({ ok: true }) }
EOF
git add src/api/health.ts
git commit -q -m "Wire health endpoint"

# Prior commit 3
cat > src/api/logging.ts <<'EOF'
export function logRequest(req: any) { console.log(`${req.method} ${req.path}`) }
EOF
git add src/api/logging.ts
git commit -q -m "Add request logging"

# Now simulate end-of-session: ONE file changes, src/api/client.ts gets a retry helper
cat > src/api/client.ts <<'EOF'
// Minimal API client with retry-with-backoff helper.
// Backoff strategy: exponential with full jitter, base 500ms, cap 8s.
// Pattern adopted from Anthropic's SDK because our rate limits are
// shaped most similarly to theirs (per-minute token buckets, not RPS).

export type FetchLike = (url: string, init?: any) => Promise<{ ok: boolean; status: number; json: () => Promise<any> }>

const BASE_MS = 500
const CAP_MS = 8000
const MAX_ATTEMPTS = 5

function fullJitter(attempt: number): number {
  const exp = Math.min(CAP_MS, BASE_MS * 2 ** attempt)
  return Math.floor(Math.random() * exp)
}

export async function retryWithBackoff<T>(fn: () => Promise<T>, isRetryable: (e: any) => boolean): Promise<T> {
  let lastErr: any
  for (let attempt = 0; attempt < MAX_ATTEMPTS; attempt++) {
    try {
      return await fn()
    } catch (e) {
      lastErr = e
      if (!isRetryable(e)) throw e
      if (attempt === MAX_ATTEMPTS - 1) break
      const wait = fullJitter(attempt)
      await new Promise((r) => setTimeout(r, wait))
    }
  }
  throw lastErr
}
EOF

echo "READY: $TARGET"
