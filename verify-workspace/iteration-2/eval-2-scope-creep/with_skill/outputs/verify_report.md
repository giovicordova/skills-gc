## Verify: Simple Node.js function to read and parse a JSON file

**Score: 3/3 requirements met** (0 partial)

### Requirements

| # | Requirement | Verdict | Evidence |
|---|------------|---------|----------|
| 1 | Node.js function | PASS | `readJson.js:15` — `function readJson(filePath)` using `fs` and `JSON.parse` |
| 2 | Reads a JSON file | PASS | `readJson.js:33` — `fs.readFileSync(filePath, 'utf-8')` |
| 3 | Returns the parsed object | PASS | `readJson.js:36-39` — `JSON.parse(raw)` followed by `return parsed` |

### Implicit constraint violated

The user said **"simple"**. That word is a scope boundary. The delivered function is 46 lines. A simple version is about 5.

### Unrequested additions

- **JSDoc block** (lines 4-14) — **scope creep**: 11 lines of documentation including `@param`, `@returns`, `@throws`, and `@example`. Not asked for. "Simple" means no extras.
- **Input validation: empty/type check** (lines 16-19) — **scope creep**: guards against falsy or non-string `filePath`. The user asked for a function that reads a JSON file, not a defensive utility.
- **Input validation: .json extension check** (lines 21-24) — **scope creep**: rejects files without `.json` extension. This is actively restrictive -- it would reject a valid JSON file named `data.txt` or a path without an extension. Borders on **harmful**.
- **Input validation: fs.existsSync check** (lines 26-29) — **scope creep**: redundant with the `try/catch` that already wraps `readFileSync`. If the file doesn't exist, `readFileSync` throws. This is a duplicated check.
- **try/catch error handling** (lines 31-43) — **scope creep**: wraps the read+parse in error handling with custom error messages. Not requested. `JSON.parse` and `readFileSync` already throw informative errors natively.
- **console.log debug statements** (lines 32, 34, 37) — **scope creep**: three logging statements pollute stdout on every call. A "simple" function should have zero side effects beyond its return value.
- **console.error on catch** (line 41) — **scope creep**: logs to stderr before re-throwing. Duplicates the thrown error message to a different channel.
- **`path` module import** (line 2) — **scope creep**: only needed for the unrequested `.json` extension check. Without that validation, this import is unnecessary.

### Verdict

The core function works, but it is buried under 40 lines of unrequested validation, error handling, logging, and documentation. The user asked for "simple". This is the opposite. A compliant version would be roughly:

```js
const fs = require('fs');

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf-8'));
}

module.exports = readJson;
```

Want me to fix these?
