// Application configuration
// Loads environment variables and exposes a configured database client.

const { Pool } = require('pg');

const databaseUrl = process.env.DATABASE_URL;

if (!databaseUrl) {
  throw new Error('DATABASE_URL is not set. Check your .env file.');
}

const pool = new Pool({
  connectionString: databaseUrl,
  max: 10,
  idleTimeoutMillis: 30000,
});

pool.on('error', (err) => {
  console.error('Unexpected database pool error', err);
});

module.exports = {
  databaseUrl,
  pool,
};
