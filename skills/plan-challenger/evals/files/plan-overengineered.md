# Plan: Add Dark Mode Toggle to Portfolio Site

## Context
User has a simple static portfolio site built with HTML, CSS, and vanilla JS. 3 pages. No build tools, no framework. They want a dark/light mode toggle button.

## Steps

### Step 1: Create Theme Architecture
- Create a `ThemeManager` class in a new `src/theme/` directory
- Implement the Observer pattern so components can subscribe to theme changes
- Define a `ThemeConfig` interface with properties for all color tokens
- Create `themes/light.json` and `themes/dark.json` configuration files

### Step 2: Build the CSS Custom Properties System
- Create `css/variables.css` with 45+ CSS custom properties for every color used
- Create a `css/theme-transitions.css` for smooth transitions between themes
- Add a `css/theme-utilities.css` with helper classes like `.theme-aware`, `.invert-on-dark`
- Write a script that auto-generates CSS variables from the JSON theme files

### Step 3: Create the Toggle Component
- Build a custom Web Component `<theme-toggle>` with Shadow DOM
- Add SVG animations for sun/moon icons with morphing transitions
- Implement keyboard accessibility (Enter, Space, Arrow keys)
- Add ARIA labels and screen reader announcements for theme changes
- Create unit tests for the toggle component

### Step 4: Implement Persistence Layer
- Create a `StorageAdapter` abstraction that supports localStorage, sessionStorage, and cookies
- Add fallback detection: try localStorage first, fall back to cookies, then session
- Implement a `PreferenceSync` module that syncs preferences across tabs using BroadcastChannel API
- Add server-side preference detection via `Sec-CH-Prefers-Color-Scheme` header

### Step 5: System Preference Detection
- Listen for `prefers-color-scheme` media query changes
- Create a priority system: manual override > stored preference > system preference > default
- Add a "System" option alongside Light and Dark
- Write integration tests for preference cascade

### Step 6: Migration and Backwards Compatibility
- Write a migration script for users who visited before dark mode existed
- Add feature detection for browsers that don't support CSS custom properties
- Create polyfills for older browsers
- Add a `<noscript>` fallback

### Step 7: Documentation and Testing
- Write JSDoc for all classes and methods
- Create a THEMES.md explaining the architecture
- Set up Vitest for unit tests
- Add Playwright tests for visual regression
- Document how to add new themes in the future

### Step 8: Performance Optimization
- Implement critical CSS extraction for above-the-fold theme styles
- Add `will-change` hints for animated properties
- Create a build step to tree-shake unused theme variables
- Measure and document Lighthouse score impact
