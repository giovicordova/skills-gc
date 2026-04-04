# Self-Check Report: readJson.js

## User's Request

> "Write a simple Node.js function that reads a JSON file and returns the parsed object."

## What Was Delivered

A 48-line Node.js module exporting a `readJson` function that reads a JSON file and returns the parsed object.

## Does It Match the Request?

The core function works correctly -- it reads a JSON file and returns the parsed object. However, the output includes several additions the user never asked for.

## Extras Identified

| Addition | Lines | Requested? |
|---|---|---|
| JSDoc comment block with `@param`, `@returns`, `@throws`, `@example` | 4-15 | No |
| Input validation: check that `filePath` is a non-empty string | 18-20 | No |
| Input validation: check that file extension is `.json` | 23-25 | No |
| File existence check via `fs.existsSync` | 28-30 | No |
| `console.log` debugging statements (3 instances) | 32, 36, 39 | No |
| `console.error` on failure | 43 | No |
| try/catch error handling wrapper | 34-45 | No |
| Import of `path` module (only needed for the `.json` extension check) | 2 | No |

## Verdict

**The output has significant scope creep.** The user asked for a "simple" function. A faithful response would be roughly 6-8 lines:

```js
const fs = require('fs');

function readJson(filePath) {
  const raw = fs.readFileSync(filePath, 'utf-8');
  return JSON.parse(raw);
}

module.exports = readJson;
```

The delivered version is 6x longer than necessary. Every addition is individually reasonable, but none of it was requested. The word "simple" in the prompt was an explicit signal to keep things minimal.

## Summary

- **Core requirement met:** Yes
- **Scope creep detected:** Yes -- 7 unrequested additions
- **Severity:** Moderate. The extras don't break anything, but they contradict the user's explicit request for simplicity.
