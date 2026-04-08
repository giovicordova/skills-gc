#!/bin/bash
# Eval 3 — fresh session, user references prior work. Test the READING flow.
set -e
DIR=$(mktemp -d -t checkpoint-e3-XXXXXX)
cd "$DIR"
git init -q -b main
git config user.email eval@example.com
git config user.name "Eval"

cat > README.md <<'EOF'
# Example App
EOF
git add README.md
git commit -q -m "Initial"

# --- Session 1: marketing landing page (unrelated) ---
mkdir -p web
cat > web/styles.css <<'EOF'
body { font-family: system-ui; }
EOF
cat > CHECKPOINTS.md <<'EOF'
# Checkpoints

One-sentence summary per session, newest first. For the full story of a
session, run: `git log --all --grep="<the exact title>" -1`

- 2026-04-05 — Polished the marketing landing page in web/styles.css and removed the unused hero animation.
EOF

cat > /tmp/checkpoint-body-1.txt <<'EOF'
Polished the marketing landing page in web/styles.css and removed the unused hero animation.

Cleaned up the marketing landing page typography and killed a leftover
hero animation that nobody liked.

What was done:
- Edited web/styles.css: switched the body font to system-ui, tightened
  line-height to 1.5, bumped the h1 size from 2.2rem to 2.8rem.
- Removed the @keyframes hero-pulse block and the .hero animation rule.

Decisions:
- User wanted Inter via Google Fonts. Rejected in favour of system-ui
  because the page needs to load instantly on 3G and Google Fonts adds
  ~120ms per fresh visit.

State at end of session: marketing page is shipped. No follow-up.
EOF

git add -A
git commit -q -F /tmp/checkpoint-body-1.txt

# --- Session 2: THE auth thing (the one the user will ask about) ---
cat > CHECKPOINTS.md <<'EOF'
# Checkpoints

One-sentence summary per session, newest first. For the full story of a
session, run: `git log --all --grep="<the exact title>" -1`

- 2026-04-06 — Traced the staging logout bug to a nginx cookie domain mismatch and planned a Monday config fix — no code change.
- 2026-04-05 — Polished the marketing landing page in web/styles.css and removed the unused hero animation.
EOF

cat > /tmp/checkpoint-body-2.txt <<'EOF'
Traced the staging logout bug to a nginx cookie domain mismatch and planned a Monday config fix — no code change.

Investigated why users on staging are logged out on every request. No
code was changed. This is a diagnosis-only session.

What was done:
- Read app/auth.py — the app sets the session cookie with
  domain=.example.com, which is correct. Code is fine.
- Checked infra/nginx/staging.conf — the proxy is NOT rewriting the
  Set-Cookie domain. That's the hole.
- Verified with the user via browser devtools: cookie is set on each
  response but never sent back on the next request.

Root cause: staging.example.com terminates TLS with a wildcard cert and
the upstream hostname nginx uses internally differs from the public host.
Chrome silently rejects the parent-domain cookie when the SNI + cookie
domain alignment breaks, which only happens on staging, not prod.

Decision: do NOT touch app/auth.py — it is correct. Fix belongs in
infra/nginx/staging.conf via a proxy_cookie_domain directive. Giovanni
will make the nginx change himself on Monday during the maintenance
window.

State at end of session: diagnosis only. Code in app/auth.py is fine.
Fix is queued for Monday in infra/nginx/staging.conf.
EOF

git add CHECKPOINTS.md
git commit -q -F /tmp/checkpoint-body-2.txt

# --- Session 3: CSV import (unrelated) ---
mkdir -p scripts
cat > scripts/import_csv.py <<'EOF'
import csv
def load(path):
    with open(path) as f:
        return list(csv.DictReader(f))
EOF
cat > CHECKPOINTS.md <<'EOF'
# Checkpoints

One-sentence summary per session, newest first. For the full story of a
session, run: `git log --all --grep="<the exact title>" -1`

- 2026-04-07 — Added scripts/import_csv.py to batch-load supplier data and wrote a smoke test against the sample file.
- 2026-04-06 — Traced the staging logout bug to a nginx cookie domain mismatch and planned a Monday config fix — no code change.
- 2026-04-05 — Polished the marketing landing page in web/styles.css and removed the unused hero animation.
EOF

cat > /tmp/checkpoint-body-3.txt <<'EOF'
Added scripts/import_csv.py to batch-load supplier data and wrote a smoke test against the sample file.

Added a CSV import helper for supplier data.

What was done:
- Created scripts/import_csv.py using csv.DictReader.
- Ran it against the sample supplier file — loaded 412 rows cleanly.
- User confirmed the column layout matches the real supplier exports.

Decisions: used stdlib csv instead of pandas because the script runs on
a minimal container and we did not want to add a dependency for one
file.

State at end of session: done.
EOF

git add -A
git commit -q -F /tmp/checkpoint-body-3.txt

rm -f /tmp/checkpoint-body-1.txt /tmp/checkpoint-body-2.txt /tmp/checkpoint-body-3.txt

echo "$DIR"
