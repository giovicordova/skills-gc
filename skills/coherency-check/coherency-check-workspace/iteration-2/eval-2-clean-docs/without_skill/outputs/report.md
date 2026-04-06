# Coherency Check: Metronome (VISION / SPEC / ROADMAP)

## Verdict

The three documents are well-aligned. No contradictions found. A handful of minor gaps where one document is silent on something another document mentions.

---

## Cross-document consistency matrix

| Claim | VISION | SPEC | ROADMAP | Status |
|---|---|---|---|---|
| Tempo range 20-300 BPM | 20 to 300 BPM | 20-300 BPM | 20-300 BPM | Consistent |
| 1 BPM resolution | 1 BPM increments | 1 BPM resolution | -- | Consistent (roadmap silent but not contradictory) |
| Denominators 4, 8, 16 | Y is 4, 8, or 16 | Denominators: 4, 8, 16 | 4, 8, 16 denominators | Consistent |
| Common time signatures 4/4, 3/4, 6/8 | Listed | Listed (4/4 default) | -- | Consistent |
| Numerator range | "any X" (unbounded) | 1-32 | -- | See finding 1 |
| First-beat accent always on | "first beat always accented" | -- | -- | See finding 2 |
| Tap tempo | Present | Present (4-tap average, outlier discard) | Present | Consistent |
| Presets | "save and recall" | localStorage, max 20, FIFO eviction | "up to 20 presets" | Consistent |
| Vanilla JS / no framework | -- | Stated | -- | Not contradicted |
| Mobile responsive | -- | -- | Listed in v1.0 | Not contradicted |

---

## Findings

### Finding 1 -- Numerator range is vague in the vision

- **VISION** says "any X/Y where Y is 4, 8, or 16" with no upper bound on X.
- **SPEC** constrains the numerator to 1-32.
- **Severity**: Low. The spec tightens the vision, which is fine -- but if someone reads only the vision they could expect, say, 64/4. Worth adding "numerator 1-32" to the vision for clarity, or at least "reasonable numerators".

### Finding 2 -- First-beat accent rule is vision-only

- **VISION** states "first beat always accented".
- **SPEC** describes accent patterns as "array of booleans, length = numerator" but does not enforce first-beat-always-on.
- **Severity**: Low. The spec's data model allows the first beat to be unaccented, which contradicts the vision's intent. If first-beat accent is a hard rule, the spec should say so (e.g., "index 0 is always true"). If it's optional, the vision should be softened.

### Finding 3 -- Mobile responsiveness is roadmap-only

- **ROADMAP** v1.0 includes "Mobile-responsive layout" as a shipped feature.
- **VISION** and **SPEC** do not mention mobile or responsive design.
- **Severity**: Low. Not a contradiction -- just an omission. If mobile is important enough to be in the v1.0 checklist, the spec should note any layout or touch-target requirements.

### Finding 4 -- Spec silent on future features

- **ROADMAP** v1.1 introduces tempo ramp, practice timer, and subdivision toggle. v2.0 introduces URL sharing, WebSocket sync, and band mode.
- **SPEC** covers only v1.0 scope and does not mention these.
- **Severity**: None (expected). Just noting that the spec will need updates before v1.1 work begins.

### Finding 5 -- Preset eviction policy stated only in spec

- **SPEC** says "Oldest deleted when limit reached" (FIFO eviction).
- **VISION** and **ROADMAP** are silent on eviction behaviour.
- **Severity**: None. This is implementation detail that belongs in the spec. No action needed.

---

## Summary

These documents are coherent. The two items worth addressing before handoff:

1. **Align numerator bounds** -- either add "1-32" to the vision or explain the constraint in a note.
2. **Clarify first-beat accent rule** -- the vision says always-on, but the spec's data model does not enforce it. Pick one and make both documents agree.

Everything else is clean.
