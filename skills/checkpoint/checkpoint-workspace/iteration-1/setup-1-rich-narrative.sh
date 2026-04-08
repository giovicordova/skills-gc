#!/bin/bash
# Eval 1 — rich narrative code session with rejected alternative and dead end
set -e
DIR=$(mktemp -d -t checkpoint-e1-XXXXXX)
cd "$DIR"
git init -q -b main
git config user.email eval@example.com
git config user.name "Eval"

cat > README.md <<'EOF'
# Widget Factory
Internal tool for managing widget inventory.
EOF
mkdir -p src tests
cat > src/widgets.py <<'EOF'
def list_widgets():
    return []
EOF
cat > tests/test_widgets.py <<'EOF'
from src.widgets import list_widgets
def test_empty():
    assert list_widgets() == []
EOF
git add -A
git commit -q -m "Initial skeleton"

# Simulated in-session changes
cat > src/widgets.py <<'EOF'
def list_widgets():
    rows = list(_load_from_db())
    return sorted(rows, key=lambda w: w.created_at, reverse=True)

def _load_from_db():
    # TODO: connect to real db
    return iter([])
EOF
cat > src/filters.py <<'EOF'
def by_colour(widgets, colour):
    return [w for w in widgets if w.colour == colour]
EOF
cat > tests/test_filters.py <<'EOF'
from src.filters import by_colour
def test_filter_empty():
    assert by_colour([], "red") == []
EOF
# Untracked draft the user does NOT want committed
cat > config.draft.yml <<'EOF'
db:
  host: localhost
  port: 5432
EOF

# Fake session transcript — this is the subagent's "memory" of what happened
cat > SESSION-NOTES.txt <<'EOF'
SESSION TRANSCRIPT — what the user and Claude actually did in this session.
Read this carefully. This is your only record of what happened. Use it to
write the checkpoint.

[10:02] User: I need list_widgets() to return widgets sorted by creation
date, newest first. Also add colour filtering as a separate module.

[10:05] Claude: Implemented list_widgets() with sorted() in src/widgets.py,
added src/filters.py with by_colour(), added tests/test_filters.py.

[10:18] Dead end: sorted() was returning in the wrong order. Claude spent
~15 minutes adding a reversed=True kwarg to sorted(), then to the inner
call, then wrapping in reversed() — nothing changed the output. Root cause
turned out to be that _load_from_db() returned a generator that had already
been consumed by a debug print statement a few lines earlier. Fix was
wrapping the call in list() before sorting.

[10:40] Rejected alternative: User suggested adding @functools.lru_cache
to _load_from_db() for performance. Claude and user discussed it and
decided AGAINST it — widgets get mutated in the DB out-of-band and a stale
cache would be worse than no cache. The user wants this reasoning recorded
so future-Claude doesn't reintroduce caching.

[10:55] User started drafting config.draft.yml for the DB connection but
it's NOT ready to commit — Giovanni wants to review it tomorrow before it
goes in. Keep it untracked.

[11:00] User: OK /checkpoint please, I'm going to /clear after.
EOF

echo "$DIR"
