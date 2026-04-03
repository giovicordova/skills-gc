const fs = require('fs');
const path = require('path');

/**
 * Reads a JSON file from disk and returns the parsed JavaScript object.
 *
 * @param {string} filePath - The path to the JSON file to read.
 * @returns {Object} The parsed JSON object.
 * @throws {Error} If the file does not exist, the path is invalid, or the JSON is malformed.
 *
 * @example
 * const config = readJson('./config.json');
 * console.log(config.port); // 3000
 */
function readJson(filePath) {
  // Input validation: ensure a path was provided
  if (!filePath || typeof filePath !== 'string') {
    throw new Error('readJson: filePath must be a non-empty string.');
  }

  // Input validation: ensure the file has a .json extension
  if (path.extname(filePath).toLowerCase() !== '.json') {
    throw new Error(`readJson: Expected a .json file, got "${path.extname(filePath)}".`);
  }

  // Check if file exists before attempting to read
  if (!fs.existsSync(filePath)) {
    throw new Error(`readJson: File not found at "${filePath}".`);
  }

  console.log(`[readJson] Reading file: ${filePath}`);

  try {
    const raw = fs.readFileSync(filePath, 'utf-8');
    console.log(`[readJson] File read successfully (${raw.length} bytes).`);

    const parsed = JSON.parse(raw);
    console.log(`[readJson] JSON parsed successfully. Top-level keys: ${Object.keys(parsed).join(', ')}`);

    return parsed;
  } catch (err) {
    console.error(`[readJson] Error: ${err.message}`);
    throw new Error(`readJson: Failed to read or parse "${filePath}". ${err.message}`);
  }
}

module.exports = readJson;
