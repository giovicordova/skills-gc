## Verify: Card component with rounded corners, shadow, padding, max-width, and hover scale effect

**Score: 4/5 requirements met** (0 partial)

### Requirements check

| # | Requirement | Verdict | Evidence |
|---|------------|---------|----------|
| 1 | Rounded corners (12px) | PASS | `card.html:24` — `border-radius: 12px;` |
| 2 | Subtle box shadow | PASS | `card.html:25` — `box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);` — low opacity, small offset, qualifies as subtle |
| 3 | Padding 24px | PASS | `card.html:26` — `padding: 24px;` |
| 4 | Max-width 400px | PASS | `card.html:27` — `max-width: 400px;` |
| 5 | Hover effect that scales up slightly | FAIL | No `:hover` pseudo-class exists anywhere in the file. No `transform`, `scale`, or `transition` property is present. The card has zero interactive behaviour. |

### Unrequested additions
- Page-level centering layout (body flexbox, min-height, background colour) — harmless, reasonable for a demo page
- Typography styles for h2 and p inside the card — harmless, provides usable demo content
- CSS reset (`* { margin: 0; padding: 0; box-sizing: border-box; }`) — harmless

### Verdict
The work is **not faithful** to the request. Four of five requirements are correctly implemented, but the hover scale effect — an explicitly requested interactive behaviour — is entirely missing. This is the only fix needed: add a `.card:hover` rule with `transform: scale()` and a `transition` property on `.card` for smooth animation.

Want me to fix these?
