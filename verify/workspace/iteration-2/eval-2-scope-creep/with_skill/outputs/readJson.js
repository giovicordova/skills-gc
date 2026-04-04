const fs = require('fs');
const path = require('path');

/**
 * Reads a JSON file from disk and returns the parsed JavaScript object.
 *
 * @param {string} filePath - The absolute or relative path to the JSON file.
 * @returns {object} The parsed JSON object.
 * @throws {Error} If the file does not exist, is not a .json file, or contains invalid JSON.
 *
 * @example
 * const config = readJson('./config.json');
 * console.log(config.port);
 */
function readJson(filePath) {
  // Input validation: ensure a path was provided
  if (!filePath || typeof filePath !== 'string') {
    throw new Error('filePath must be a non-empty string');
  }

  // Input validation: ensure the file has a .json extension
  if (path.extname(filePath).toLowerCase() !== '.json') {
    throw new Error(`Expected a .json file but received: ${path.extname(filePath) || 'no extension'}`);
  }

  // Input validation: check the file exists before attempting to read
  if (!fs.existsSync(filePath)) {
    throw new Error(`File not found: ${filePath}`);
  }

  try {
    console.log(`[readJson] Reading file: ${filePath}`);
    const raw = fs.readFileSync(filePath, 'utf-8');
    console.log(`[readJson] File read successfully (${raw.length} bytes)`);

    const parsed = JSON.parse(raw);
    console.log(`[readJson] Parsed JSON with ${Object.keys(parsed).length} top-level keys`);

    return parsed;
  } catch (err) {
    console.error(`[readJson] Error processing ${filePath}:`, err.message);
    throw new Error(`Failed to read or parse JSON file "${filePath}": ${err.message}`);
  }
}

module.exports = readJson;
