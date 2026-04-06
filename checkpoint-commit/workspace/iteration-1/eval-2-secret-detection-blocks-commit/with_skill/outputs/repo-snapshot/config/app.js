const { Pool } = require('pg');

// Database connection configuration. The URL is read from the
// environment so the same code works in dev, staging, and prod
// without any credentials landing in the repo.
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
  console.error('Unexpected pg pool error', err);
});

module.exports = { pool };
