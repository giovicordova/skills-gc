## Verify: Simple Node.js function to read a JSON file and return the parsed object

**Score: 3/4 requirements met** (1 partial)

### Requirements check

| # | Requirement | Verdict | Evidence |
|---|------------|---------|----------|
| 1 | Write a Node.js function | PASS | `readJson.js`: line 15 defines `function readJson(filePath)` using `fs` and `path` from Node core. |
| 2 | Reads a JSON file | PASS | `readJson.js`: line 34 calls `fs.readFileSync(filePath, 'utf-8')`. |
| 3 | Returns the parsed object | PASS | `readJson.js`: line 37 calls `JSON.parse(raw)`, line 40 returns `parsed`. |
| 4 | Should be simple | PARTIAL | The user explicitly asked for "a simple" function. The delivered file is 47 lines with multiple validation gates, try/catch, and debug logging. A simple version would be ~5 lines. This is not simple. |

### Unrequested additions

- **JSDoc comment block** (lines 4-13) — scope creep. The user asked for a simple function, not documented API. Adds 10 lines of overhead.
- **Input validation: empty/type check** (lines 17-19) — scope creep. Throws if `filePath` is falsy or not a string. Not requested.
- **Input validation: .json extension check** (lines 22-24) — scope creep. Rejects files that don't end in `.json`. Not requested, and actively harmful -- valid JSON files can have other extensions (e.g., `.geojson`, `.jsonc`, or no extension at all).
- **File existence check with `fs.existsSync`** (lines 27-29) — scope creep. Redundant -- `fs.readFileSync` already throws `ENOENT` if the file doesn't exist. This adds a TOCTOU race condition for no benefit.
- **`console.log` debug statements** (lines 31, 35, 38) — scope creep. Three log statements that pollute stdout in production. The user didn't ask for logging.
- **`console.error` statement** (line 42) — scope creep. Error logging inside the catch block before re-throwing. Caller should decide how to log.
- **try/catch with re-thrown custom error** (lines 33-44) — scope creep. Wraps the native error in a new `Error`, losing the original stack trace. The user didn't ask for error handling.
- **`require('path')` import** (line 2) — scope creep. Only needed for the unrequested `.json` extension check. Unnecessary dependency.

### Verdict

The core function works -- it reads JSON and returns the parsed object. But it fails the "simple" requirement. The user asked for a simple function and got 47 lines of defensive programming, debug logging, and documentation they never requested. A faithful implementation would be roughly:

```js
const fs = require('fs');
function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf-8'));
}
module.exports = readJson;
```

The most important fix: strip everything except the core read-and-parse logic. Every addition here is unrequested scope creep.

---

Want me to fix these?
