# State Management Pattern Assessment: Redux Toolkit + React Context + Local useState

## Verdict

The pattern is coherent. Redux Toolkit for global state, React Context for theme/auth, and local `useState` for form data is a well-established, recommended approach in the React ecosystem. You do not have an overlap problem -- you have a layered architecture where each tool handles a different scope of state.

---

## Why This Works

Each layer owns a distinct concern:

| Layer | Tool | What it manages | Why this tool fits |
|---|---|---|---|
| **Global app state** | Redux Toolkit | Data shared across many components -- user profiles, fetched entities, notifications, feature flags | Predictable updates, middleware for async, DevTools for debugging, scales well |
| **Cross-cutting UI concerns** | React Context | Theme (light/dark), auth status/tokens, locale | Rarely changes, consumed broadly, no complex update logic -- Context handles this without Redux overhead |
| **Component-local state** | `useState` | Form inputs, toggles, modals, transient UI state | Ephemeral, owned by one component, no reason to hoist it |

The React team, Redux maintainers (Mark Erikson specifically), and the Redux Toolkit documentation all explicitly recommend this exact combination. It is not accidental overlap -- it is intentional separation of concerns.

---

## Where Overlap Actually Creeps In (What to Watch For)

The pattern is sound in principle, but here are the specific ways it breaks down in practice:

### 1. Auth state living in both Context and Redux

This is the most common violation. If your auth Context provides `user`, `isAuthenticated`, and `roles`, but your Redux store also has a `user` slice with profile data, you have two sources of truth for user identity. Pick one owner. Typically: auth tokens and login state in Context, user profile data (name, preferences, permissions) in Redux.

**Test**: search your codebase for `useContext(AuthContext)` and any Redux selector that reads user data. If both return overlapping fields, you have a problem.

### 2. Form state leaking into Redux

If any form data (input values, validation errors, dirty/touched flags) lives in Redux, that is unnecessary complexity. Form state is inherently local and transient. It should stay in `useState` or a form library (React Hook Form, Formik). Redux is for state that persists after the form closes.

**Test**: check your Redux slices for anything named `form`, `input`, `draft`, or `editing`. If found, it likely belongs in local state.

### 3. Theme/UI state fragmenting across layers

If your Context provides `theme` but individual components also store UI preferences in Redux (sidebar collapsed, table sort order, selected tab), you have theme-adjacent state scattered across two systems. This is not necessarily wrong -- but document the boundary. Context = design system tokens. Redux = persistent UI preferences. `useState` = transient UI toggles.

### 4. Derived state duplicated instead of computed

If the same computed value (e.g., "is the user an admin with an active subscription") exists as a stored value in both Context and Redux, you have a staleness risk. Use Redux Toolkit's `createSelector` (via reselect) to derive this from a single source.

---

## Decision Framework

When adding new state, ask three questions in order:

1. **Does only one component (and its children) need this?** --> `useState` or `useReducer`
2. **Is it a cross-cutting concern with infrequent updates (theme, locale, auth session)?** --> React Context
3. **Is it shared across unrelated parts of the app, updated frequently, or needs middleware (async, logging)?** --> Redux Toolkit

If the answer is ambiguous, default to the simplest option (`useState`) and promote upward only when you hit a concrete problem -- not speculatively.

---

## Quick Audit Checklist

Run these checks against your codebase to confirm you are clean:

- [ ] No Redux slice stores form input values
- [ ] Auth Context and Redux user slice do not store overlapping fields
- [ ] No component reads the same data from both `useSelector` and `useContext`
- [ ] Theme Context does not contain business logic or API-fetched data
- [ ] No `useState` holds data that multiple sibling components need (symptom: prop drilling more than 2 levels)
- [ ] Redux selectors use `createSelector` for derived values rather than storing computed state

---

## Bottom Line

Your architecture is standard and correct. The risk is not in the pattern itself but in boundary drift over time -- state migrating to the wrong layer as features grow. The checklist above catches that early. If your codebase passes those checks, you are in good shape.
