# Coherency Check — Metronome (VISION / SPEC / ROADMAP)

## Verdict: Fully coherent

All three documents align cleanly. No contradictions, no conflicting values, no missing connections.

---

## Cross-document alignment

| Element | VISION | SPEC | ROADMAP |
|---------|--------|------|---------|
| BPM range | 20–300, 1 BPM increments | 20–300, 1 BPM resolution | 20–300 BPM (v1.0 checkbox) |
| Time signatures | common (4/4, 3/4, 6/8) + custom (Y = 4, 8, 16) | denominators 4, 8, 16; numerator 1–32; presets 4/4, 3/4, 6/8 | denominators 4, 8, 16 (v1.0 checkbox) |
| Accent patterns | first beat accented, additional configurable | accent stored as boolean array, length = numerator | accent pattern editor (v1.0 checkbox) |
| Tap tempo | tap a button to set BPM from feel | averages last 4 intervals, discards outliers > 2 SD | tap tempo (v1.0 checkbox) |
| Presets | save and recall tempo + time signature combos | localStorage, max 20, saves name/BPM/time sig/accents | up to 20 presets (v1.0 checkbox) |

Every feature promised in the vision is specified technically in the spec and tracked as complete in the roadmap.

---

## Minor observations (non-blocking)

1. **Vision says "tempo + time signature combinations" for presets; Spec also stores accent pattern.** This is additive, not contradictory — the spec simply includes more detail. No action needed unless you want the vision to explicitly mention accent patterns in presets.

2. **Roadmap v1.1 and v2.0 features have no corresponding spec sections yet.** Expected — they're future work. Just note that when you begin v1.1, the spec will need entries for tempo ramp, practice timer, and subdivision toggle.

---

## Summary

These three documents are ready to hand off. They tell a consistent story: what the product is (vision), how it works (spec), and when each piece ships (roadmap).
