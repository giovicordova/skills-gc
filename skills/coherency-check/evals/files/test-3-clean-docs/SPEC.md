# Technical Specification

## Architecture

Single-page web app built with vanilla JavaScript. No framework — keeps bundle size minimal for fast load on mobile.

## Audio Engine

Uses the Web Audio API (`AudioContext`) for precise timing. The scheduler runs 25ms ahead and uses `setTimeout` for the lookahead loop, following Chris Wilson's "A Tale of Two Clocks" pattern.

## Tempo

- Range: 20–300 BPM
- Resolution: 1 BPM
- Tap tempo: averages the last 4 tap intervals, discards outliers > 2 standard deviations

## Time Signatures

Supported denominators: 4, 8, 16. Numerator: 1–32.

Common presets:
- 4/4 (default)
- 3/4
- 6/8

## Presets

Stored in `localStorage`. Each preset saves:
- Name
- BPM
- Time signature (numerator + denominator)
- Accent pattern (array of booleans, length = numerator)

Maximum 20 presets. Oldest deleted when limit reached.
