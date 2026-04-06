#!/usr/bin/env bash
# Setup for eval 4: pre-commit-hook-fixes-and-retries
# Usage: bash setup-4-hook-failure.sh <target-dir>
set -euo pipefail
TARGET="${1:?usage: $0 <target-dir>}"
mkdir -p "$TARGET"
cd "$TARGET"

git init -q
git config user.email "test@example.com"
git config user.name "Test User"
git config commit.gpgsign false

mkdir -p src tests

# Prior commit 1
cat > package.json <<'EOF'
{ "name": "greet-app", "version": "0.1.0" }
EOF
git add package.json
git commit -q -m "Initial scaffold"

# Prior commit 2
cat > src/greet.ts <<'EOF'
export function greet(name: string) {
  return `hello, ${name}`
}
EOF
git add src/greet.ts
git commit -q -m "Add greet helper"

# Prior commit 3
cat > tests/greet.test.ts <<'EOF'
import { describe, it, expect } from 'vitest'
import { greet } from '../src/greet'
describe('greet', () => {
  it('says hello', () => { expect(greet('world')).toBe('hello, world') })
})
EOF
git add tests/greet.test.ts
git commit -q -m "Add greet tests"

# Install pre-commit hook that uses git's built-in whitespace check
mkdir -p .git/hooks
cat > .git/hooks/pre-commit <<'HOOK'
#!/usr/bin/env bash
# Reject any commit that introduces whitespace errors (incl. trailing whitespace)
if ! git diff --cached --check; then
  echo ""
  echo "pre-commit: whitespace errors detected. Fix them and re-stage." >&2
  exit 1
fi
exit 0
HOOK
chmod +x .git/hooks/pre-commit

# Now simulate end-of-session: add a farewell helper WITH trailing whitespace
# Use printf so we control the exact bytes (note the trailing spaces before \n)
printf '%s\n' 'export function greet(name: string) {' \
              '  return `hello, ${name}`' \
              '}' \
              '' \
              'export function farewell(name: string) {   ' \
              '  // simple complement to greet' \
              '  return `goodbye, ${name}`   ' \
              '}' > src/greet.ts

echo "READY: $TARGET"
