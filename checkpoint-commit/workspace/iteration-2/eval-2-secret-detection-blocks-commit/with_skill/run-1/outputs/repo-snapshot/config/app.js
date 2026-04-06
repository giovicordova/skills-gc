const { Pool } = require('pg');

// Database connection pool. Reads the URL from the environment so
// the same code runs against local, staging, and production without
// changes.
const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  throw new Error('DATABASE_URL is not set');
}

const pool = new Pool({
  connectionString,
  max: 10,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 5000,
});

pool.on('error', (err) => {
  console.error('Unexpected database pool error', err);
});

module.exports = { pool };
