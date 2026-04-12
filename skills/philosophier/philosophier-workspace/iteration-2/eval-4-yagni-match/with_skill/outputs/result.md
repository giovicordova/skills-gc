### Before
Do not add features, refactor code, or make improvements beyond what was asked. A bug fix doesn't need surrounding code cleaned up. A simple feature doesn't need extra configurability. Don't add docstrings, comments, or type annotations to code you didn't change. Only add comments where the logic isn't self-evident. Don't add error handling, fallbacks, or validation for scenarios that can't happen. Trust internal code and framework guarantees. Only validate at system boundaries. Don't create helpers, utilities, or abstractions for one-time operations. Don't design for hypothetical future requirements. The right amount of complexity is what the task actually requires — no speculative abstractions, but no half-finished implementations either.

### After
YAGNI — do exactly what was asked, nothing around it. Don't touch unchanged code (no cleanup, no docstrings, no type annotations). Comment only non-obvious logic. Validate at system boundaries only — trust internals. No one-use abstractions, no design for hypothetical futures. Match complexity to the task: no speculation, no shortcuts.

### Source
YAGNI (You Aren't Gonna Need It) — Extreme Programming principle, Ron Jeffries / Kent Beck, c. 1990s. The original text is an enumeration of YAGNI violations with a bidirectional constraint (no over-engineering, no under-engineering) preserved in the final sentence.

### Dropped
Nothing. All constraints survive. "Bug fix doesn't need surrounding code cleaned up" and "simple feature doesn't need extra configurability" are subsumed by "do exactly what was asked, nothing around it." "Error handling for scenarios that can't happen" and "framework guarantees" are subsumed by "validate at system boundaries only — trust internals."
