## Coherency Check: Metronome — VISION.md, SPEC.md, ROADMAP.md

**3 files checked. No contradictions found. 1 overlap and 1 minor gap noted.**

---

### Contradictions

None. All three documents agree on every concrete value:

| Claim | VISION.md | SPEC.md | ROADMAP.md |
|-------|-----------|---------|------------|
| Tempo range | 20–300 BPM | 20–300 BPM | 20–300 BPM |
| Resolution | 1 BPM increments | 1 BPM | (not stated, no conflict) |
| Denominators | 4, 8, or 16 | 4, 8, 16 | 4, 8, 16 |
| Common time sigs | 4/4, 3/4, 6/8 | 4/4 (default), 3/4, 6/8 | (not listed individually, no conflict) |
| Tap tempo | Present | Present (4-tap average, 2 SD outlier filter) | Present |
| Preset limit | (not stated) | Maximum 20 | Up to 20 |
| Accent patterns | Present | Present (boolean array, length = numerator) | Present |

---

### Overlapping Definitions

**1. Preset contents — Vision undersells what a preset stores**

- **VISION.md, "Core Features" section:** "save and recall tempo + time signature combinations"
- **SPEC.md, "Presets" section:** each preset saves Name, BPM, Time signature (numerator + denominator), and Accent pattern (array of booleans)

The Vision omits that presets also store a name and the accent pattern. This is not a contradiction — the Vision is simply less specific — but if someone reads only the Vision they will underestimate what presets do. If the Vision is meant to be a complete feature summary, it should mention accent patterns are included in presets.

**Severity:** Low. The Spec is authoritative here; the Vision is just incomplete.

---

### Terminology Drift

None. All three files use the same terms consistently: "BPM", "time signature", "accent pattern", "preset", "tap tempo", "denominator", "numerator".

---

### Stale References

None. Every feature mentioned in the Vision appears in both the Spec and the Roadmap. The Roadmap's v1.1 and v2.0 items (tempo ramp, practice timer, subdivision toggle, preset sharing, multi-device sync, band mode) are future work and correctly not covered in the current-scope Vision or Spec.

---

### Additional Observations

**1. First-beat accent constraint — Vision states a rule the Spec does not enforce**

- **VISION.md, "Core Features" #3:** "first beat always accented, additional accents configurable"
- **SPEC.md, "Presets" section:** accent pattern is "array of booleans, length = numerator" — no mention of the first beat being locked to accented

This is a gap rather than a contradiction. The Spec's data model (a plain boolean array) would allow the first beat to be unaccented, which the Vision explicitly forbids. This could be enforced in UI logic rather than the data model, but the Spec should document that constraint somewhere — either as a validation rule or a UI behaviour note — so an implementer doesn't miss it.

**Severity:** Low-medium. An implementer reading only the Spec could build a UI that lets users un-accent beat 1, contradicting the Vision's stated design intent.

**2. Preset overflow behaviour — Spec-only detail**

The Spec states "Oldest deleted when limit reached" for the 20-preset cap. Neither the Vision nor the Roadmap mentions this. Not an inconsistency, but worth flagging: if a product decision changes this to "warn the user" or "block new saves", only the Spec needs updating.

---

### Summary

These documents are well-aligned. The numbers match, the terminology is consistent, and the Roadmap's v1.0 checklist covers exactly what the Vision and Spec describe. The two items worth addressing before handoff:

1. **Vision's preset description** could mention that accent patterns are saved with presets (minor completeness fix).
2. **Spec should document the first-beat-always-accented rule** from the Vision, either as a validation constraint or a UI behaviour note.

Neither is urgent, but both close small gaps that could cause confusion for an implementer working from a single document rather than reading all three.
