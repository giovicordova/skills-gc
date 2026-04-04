# Perspective Report — State Management Architecture
> 2026-04-04

## What You're Building

A React application that uses a three-tier state management approach: Redux Toolkit for global/domain state, React Context for theme and authentication, and local `useState` for form data. The question is whether this layered pattern is architecturally coherent or introduces overlapping concerns.

## What Already Exists

This is not a product evaluation — it is an architecture pattern evaluation. The pattern described (Redux + Context + local state) is itself a well-documented and widely recommended approach. No "alternative product" applies here.

Relevant prior art and guidance:

- **Redux official docs** — explicitly recommend using Redux only for global, mutable data and deferring to Context and local state for everything else. The Next.js integration guide states: "Redux should be used sparingly, primarily for data that is both global and mutable." ([Redux Toolkit docs](https://redux-toolkit.js.org/))
- **Mark Erikson's canonical post** — "Why React Context is Not a State Management Tool" — explains that Context is a dependency injection mechanism, not a state manager. Using it for theme/auth is exactly the intended use case. ([blog.isquaredsoftware.com](https://blog.isquaredsoftware.com/2021/01/context-redux-differences/))
- **React official docs** — recommend Context combined with `useState` for theme, auth, and locale. The docs explicitly show this pattern. ([react.dev](https://react.dev/reference/react/useContext))

## Alternative Approaches

### 1. Replace Redux Toolkit with Zustand
- **What it is:** A minimal, hook-based state management library (1KB core) that now has 14.2M weekly npm downloads vs Redux Toolkit's 9.8M.
- **How it differs:** No Provider wrapping, no boilerplate slices, no actions/reducers ceremony. Store is created outside React and consumed via hooks.
- **Trade-offs:** You gain simplicity and smaller bundle size. You lose Redux DevTools time-travel debugging, enforced structure for large teams, and RTK Query's built-in data fetching/caching. Migration is incremental (one slice at a time). Worth considering if the app is small-to-medium and the team is small.

### 2. Replace Redux Toolkit with Jotai (atomic state)
- **What it is:** Bottom-up atomic state management where each piece of state is an independent "atom."
- **How it differs:** No central store. Components subscribe to individual atoms, so re-renders are surgically precise.
- **Trade-offs:** You gain maximum render performance and composability. You lose the single-store mental model and time-travel debugging. Best for apps with many interdependent state pieces (e.g., complex dashboards, editor UIs).

### 3. Consolidate Context into Redux
- **What it is:** Move theme and auth state into Redux slices, eliminating Context entirely.
- **How it differs:** Single source of truth for all global state.
- **Trade-offs:** Fewer moving parts to reason about. But theme/auth are low-frequency, static-like values — putting them in Redux adds unnecessary indirection for data that rarely changes. The current Context approach is actually more appropriate for these concerns.

### 4. Replace Context + Redux with Zustand alone
- **What it is:** Use separate Zustand stores for different concerns (theme store, auth store, domain store).
- **How it differs:** Unified API across all state tiers, no Provider nesting.
- **Trade-offs:** Cleaner mental model. But only worth the migration cost if Context is causing actual pain (Provider Hell, performance issues from re-renders).

## Codebase Audit

Since no codebase files were provided, this audit is based on the described architecture pattern checked against current library documentation.

### What's current and solid
- **Redux Toolkit** remains the official, recommended way to use Redux. `createSlice`, `configureStore`, `useSelector`, and `useDispatch` are all current APIs with no deprecation warnings.
- **React Context** for theme/auth aligns exactly with React's official documentation examples. The React docs explicitly demonstrate `ThemeContext` and `AuthContext` as the canonical Context use cases.
- **Local `useState` for forms** is correct practice. Form data is ephemeral and component-scoped — lifting it into global state would be an anti-pattern.

### What to watch
- **RTK Query** — if the app fetches server data and manages it in Redux slices manually (with `createAsyncThunk`), RTK Query is the current recommended replacement. It handles caching, invalidation, and loading states declaratively.
- **React 19 Context syntax** — React 19 changed `<Context.Provider value={...}>` to `<Context value={...}>` (dropping `.Provider`). If you're on React 19+, the old syntax still works but is being phased out.
- **Zustand momentum** — Zustand has overtaken Redux Toolkit in weekly downloads. This doesn't mean Redux is deprecated, but it does mean the ecosystem gravity is shifting. For new projects, Zustand is increasingly the default recommendation.

### Dependency versions worth checking
- Ensure Redux Toolkit is on v2.x (current: v2.11.0). Version 1.x is outdated.
- Ensure React Redux is on v9.x for React 19 compatibility.

## Coherency

### Verdict: The pattern is coherent.

The three-tier approach (local state / Context / Redux) is not an accident of accumulated decisions — it is the officially recommended architecture from both the React and Redux documentation teams. Each tier owns a distinct concern:

| Tier | Tool | Owns | Example |
|------|------|------|---------|
| Local | `useState` | Ephemeral, component-scoped data | Form inputs, toggle states, animation flags |
| Shared static | React Context | Low-frequency, app-wide values | Theme, auth status, locale |
| Global dynamic | Redux Toolkit | Frequently changing, cross-component domain data | User profiles, app data, API cache |

### Where overlap could creep in

The pattern is coherent *if the boundaries are respected*. Common ways it breaks down:

1. **Auth state bleeding into Redux** — If auth tokens or user session data lives in both a Context provider and a Redux slice, you have competing sources of truth. Pick one. Context for "is the user logged in?" and Redux for "user profile data" is fine — but the auth token itself should live in exactly one place.

2. **Theme logic in Redux** — If someone puts theme preferences in a Redux slice because "it's global," that's unnecessary indirection. Theme changes infrequently and doesn't benefit from Redux's middleware, DevTools, or selector optimisation.

3. **Form state lifted to Redux** — If form data gets dispatched to Redux "just in case" other components need it, you're adding complexity for a speculative need. Keep form state local until a concrete requirement demands otherwise.

4. **Too many Context providers** — If the app has more than 2-3 Context providers, it's approaching "Provider Hell." Mark Erikson's rule of thumb: past 2-3 state-related contexts, you're reinventing a weaker React-Redux. If you find yourself adding more Contexts for state (not just dependency injection), consider consolidating into Redux or switching to Zustand.

### No findings for
- Duplication (no codebase to scan)
- Dead code (no codebase to scan)
- Unnecessary complexity (the described pattern itself is appropriately complex — neither over- nor under-engineered)

## Recommendation

**Stay the course** — the pattern is sound and aligns with current best practices from both the React and Redux teams.

The three-tier split (local / Context / Redux) is not an ad hoc accumulation — it is the canonical recommended architecture. Each tool is being used for its intended purpose. There is no overlap in the described setup.

The main risk is not the architecture itself but boundary discipline over time. As the app grows, developers may blur the lines between tiers (e.g., putting form state in Redux, or adding more Context providers for state that should be in Redux).

### Action Items

- [ ] Audit auth state ownership: confirm the auth token lives in exactly one place (Context or Redux, not both). User profile data in Redux is fine; the session/token itself should be in one tier only.
- [ ] Check for RTK Query opportunity: if the app manually fetches server data with `createAsyncThunk` and stores it in slices, evaluate migrating those to RTK Query for declarative caching and invalidation.
- [ ] Count Context providers: if there are more than 3 state-bearing Context providers (not counting pure dependency injection like i18n), consolidate or migrate extras into Redux slices.
- [ ] Verify dependency versions: confirm Redux Toolkit is v2.x and React Redux is v9.x. Update if behind.
- [ ] Update React Context syntax if on React 19+: migrate `<Context.Provider value={...}>` to `<Context value={...}>`.

- Consider documenting the state management boundaries (what goes where) in a short architecture decision record (ADR) or CLAUDE.md section, so new contributors don't accidentally blur the tiers. This needs a brief planning session to define the exact rules for the team.

> After implementing action items, update this file: `- [ ]` -> `- [x]`
