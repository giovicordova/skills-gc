#!/bin/bash
# Eval 2 — pure investigation, no code changes
set -e
DIR=$(mktemp -d -t checkpoint-e2-XXXXXX)
cd "$DIR"
git init -q -b main
git config user.email eval@example.com
git config user.name "Eval"

mkdir -p infra/nginx app
cat > infra/nginx/staging.conf <<'EOF'
server {
    listen 443 ssl;
    server_name staging.example.com;

    location / {
        proxy_pass http://app:3000;
        proxy_set_header Host $host;
        # NOTE: no proxy_cookie_domain rewrite here
    }
}
EOF
cat > app/auth.py <<'EOF'
def set_session_cookie(response, token):
    response.set_cookie(
        "session",
        token,
        domain=".example.com",  # parent domain
        secure=True,
        httponly=True,
    )
EOF
cat > README.md <<'EOF'
# Example App
EOF
git add -A
git commit -q -m "Initial infra + auth"

cat > SESSION-NOTES.txt <<'EOF'
SESSION TRANSCRIPT — what the user and Claude actually did in this session.
No code was changed. This was pure investigation. Read carefully.

[14:10] User: users on staging are getting logged out on every request.
prod is fine. can you dig into it?

[14:12] Claude: started by checking app/auth.py. Cookie is set on
.example.com (parent domain), which should cover both staging and prod.

[14:25] Claude: checked browser devtools (described by user): cookie is
being SET on every response but not sent back on the next request. Browser
is rejecting it silently.

[14:40] Root cause found: infra/nginx/staging.conf proxies to the app
without rewriting the Set-Cookie domain. The app sets domain=.example.com
but the browser is on staging.example.com and the upstream uses a different
hostname internally. Chrome's cookie jar rejects cross-origin parent-domain
cookies when the TLS SNI and the cookie domain don't cleanly align on
staging's wildcard cert.

[14:55] Decision: do NOT change app/auth.py — the code is correct. The fix
belongs in infra/nginx/staging.conf with a proxy_cookie_domain directive.
Giovanni wants to do the nginx change himself on Monday during the
maintenance window — not today. So today's session ends with a diagnosis
only, no code written.

[15:00] User: ok /checkpoint this and we'll clear. the important thing is
that tomorrow-Claude knows the app code is fine and the fix is an nginx
config change at infra/nginx/staging.conf, planned for Monday.
EOF

echo "$DIR"
