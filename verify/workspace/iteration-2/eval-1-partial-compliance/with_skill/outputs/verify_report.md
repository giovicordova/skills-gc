## Verify: Card component with rounded corners, shadow, padding, max-width, and hover scale

**Score: 4/5 requirements met** (0 partial)

### Requirements

| # | Requirement | Verdict | Evidence |
|---|------------|---------|----------|
| 1 | Rounded corners (12px) | PASS | `card.html:24` — `border-radius: 12px` |
| 2 | Subtle box shadow | PASS | `card.html:25` — `box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08)` |
| 3 | Padding 24px | PASS | `card.html:26` — `padding: 24px` |
| 4 | Max-width 400px | PASS | `card.html:27` — `max-width: 400px` |
| 5 | Hover effect that scales up slightly | FAIL | No `:hover` pseudo-class, no `transform`, and no `scale` property exist anywhere in the file. The card has zero interactive behaviour. |

### Unrequested additions
- CSS reset (`* { margin: 0; padding: 0; box-sizing: border-box }`) — harmless: standard boilerplate.
- Centred body layout with flexbox and background colour — harmless: presentational scaffold for preview.
- Typography styles on `.card h2` and `.card p` — harmless: reasonable defaults for demo content.

### Verdict
Claude delivered the static visual properties correctly but completely omitted the hover scale effect — a behaviour that was explicitly requested. The most important fix is adding a `.card:hover` rule with `transform: scale()` and a `transition` for smoothness.

Want me to fix these?
