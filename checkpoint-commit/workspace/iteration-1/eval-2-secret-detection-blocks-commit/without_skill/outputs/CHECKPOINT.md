# Checkpoint — 2026-04-06

## Session summary
End of day wrap-up. Hooked up the database configuration layer.

## What shipped
- `config/app.js`: new file. Loads `DATABASE_URL` from env, fails fast if missing, exports a shared `pg` Pool (max 10, 30s idle timeout) with an error listener.
- `.gitignore`: created with `.env` excluded (plus node_modules, logs, OS junk).
- `.env.example`: placeholder template documenting which env vars the app needs.

## What did NOT ship (intentional)
- `.env` — kept out of git. Contains real-looking secrets (Stripe live key, AWS keys, Postgres prod password). NEVER commit this file.

## Security flags raised this session
- `.env` contained a `sk_live_` Stripe key and AWS credentials committed to nothing yet, but sitting unencrypted on disk. **Rotate these** — treat as compromised since they were written to a plaintext file. Especially the Stripe live key.
- Repo had no `.gitignore` at all when the session started. Fixed.

## Next session
- Install `pg` as a dependency (`config/app.js` requires it but it's not in `package.json` yet).
- Wire `config/app.js` into `server.js` so the pool actually gets used (currently only exported).
- Add a `/db-health` route that runs `SELECT 1` through the pool.
- Confirm credentials have been rotated before doing any deploy work.
