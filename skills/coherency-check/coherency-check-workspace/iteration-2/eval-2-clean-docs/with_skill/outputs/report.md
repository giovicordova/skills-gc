## Coherency Check: Metronome — VISION.md, SPEC.md, ROADMAP.md

**3 files checked — 0 contradictions, 2 overlaps, 0 terminology drift, 0 stale references found.**

All three documents are well-aligned on the core facts: tempo range (20-300 BPM at 1 BPM resolution), supported time signature denominators (4, 8, 16), common presets (4/4, 3/4, 6/8), tap tempo, accent patterns, and a 20-preset limit. Terminology is consistent across all files — "BPM", "preset", "accent pattern", "time signature", and "tap tempo" are used identically everywhere.

No contradictions. No terminology drift. No stale references.

### Overlapping Definitions

**1. Preset contents — VISION vs SPEC differ in completeness**

- **VISION.md**, "Core Features" section, item 5: defines presets as saving "tempo + time signature combinations"
- **SPEC.md**, "Presets" section: defines presets as saving "name, BPM, time signature (numerator + denominator), accent pattern (array of booleans, length = numerator)"

The SPEC includes two fields (name, accent pattern) that the VISION omits. This is not a contradiction — the VISION is a summary and the SPEC is the detailed definition — but if someone reads only the VISION, they will underestimate what a preset contains. If accent patterns are a key selling point (they appear as a standalone core feature in the VISION), it is worth reflecting them in the preset description too.

**2. Mobile responsiveness — ROADMAP mentions it, VISION and SPEC do not**

- **ROADMAP.md**, v1.0 checklist: lists "Mobile-responsive layout" as a completed feature
- **SPEC.md**, "Architecture" section: mentions "fast load on mobile" as a design motivation, but does not specify mobile-responsive layout as a requirement or feature
- **VISION.md**: no mention of mobile at all

Mobile responsiveness is shipped (per the roadmap) but is not captured as a requirement in either the VISION's core features or the SPEC's architecture section. If this is an intentional scope item, it should appear in at least one of those documents so future contributors know it is a maintained commitment, not incidental.

### Notes

- The SPEC constrains the time signature numerator to 1-32. The VISION says "any X/Y where Y is 4, 8, or 16" without bounding X. Not a contradiction — the SPEC simply adds a constraint the VISION leaves open — but worth aligning if the VISION is meant to be a complete feature description.
- The SPEC details tap tempo's algorithm (averages last 4 intervals, discards outliers > 2 SD). The VISION just says "tap a button to set BPM from feel." This is expected — implementation detail belongs in the SPEC — and is not an issue.

---

These documents are coherent. The two overlaps are minor maintenance concerns — no action is required before handoff, but tidying them up would make the set self-consistent at every level of detail.
