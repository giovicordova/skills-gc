# Pulse — Style Guide

## Package Manager

Use `yarn` for all dependency management. Run `yarn install` after pulling, `yarn add` for new deps.

## Code Style

- TypeScript strict mode everywhere.
- Prefer named exports over default exports.
- Components go in `components/` with PascalCase filenames.
- Hooks go in `hooks/` with `use` prefix.

## React Patterns

- Use `useEffect` for post-render side effects — it runs after the browser has painted, so it won't block visual updates. For effects that must run before paint (measuring layout, preventing flicker), use `useLayoutEffect` instead.
- Keep client components small. Push data fetching into server components and pass results as props.
- Avoid `useEffect` for data fetching on the client — use React Query or SWR with Suspense boundaries instead.

## Styling

- Tailwind CSS utility classes only. No custom CSS files except `globals.css`.
- Design tokens defined in the Tailwind config.
- Colour palette: primary `#2563eb`, secondary `#7c3aed`, neutral grey scale.
- Dark mode via Tailwind's `dark:` variant, toggled with a class strategy.

## API Routes

API routes under `app/api/` follow REST conventions:
- `GET` for reads, `POST` for creates, `PUT` for updates, `DELETE` for deletes
- All routes return JSON with `{ data, error }` shape
- Rate limited to 200 requests per minute per user

## Testing

- Vitest for unit tests
- Playwright for E2E tests
- Minimum 80% coverage on utility functions
