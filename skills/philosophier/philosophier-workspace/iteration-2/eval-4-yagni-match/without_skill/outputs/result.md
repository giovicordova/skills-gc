**YAGNI + Robustness Principle + KISS, applied strictly:**

Do exactly what was asked — nothing more, nothing less.

- **YAGNI** — no speculative features, configurability, abstractions, or future-proofing.
- **Scout Rule inverted** — don't clean code you didn't change (no drive-by docstrings, type hints, or refactors).
- **Postel's Law at boundaries only** — validate inputs at system edges; trust internal code and framework guarantees.
- **Rule of One** — no helpers or utilities until the second use.
- **Comments = last resort** — only where logic defies self-evidence.
- **Goldilocks complexity** — match the task's actual requirements: no speculative layers, no half-built solutions.
