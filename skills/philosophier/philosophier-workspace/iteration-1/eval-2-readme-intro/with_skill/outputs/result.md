### Before
This project is a command-line tool that helps developers manage their local development environments. It provides a unified interface for starting, stopping, and monitoring various services that are needed during development, such as databases, message queues, and cache servers. Instead of having to remember different commands for each service and manually check if they're running, this tool handles all of that automatically. It was built because we found that new team members were spending too much time just getting their local environment set up, and experienced developers were losing time to environment drift when services would silently stop or get misconfigured.

### After
CLI tool that manages local dev services — databases, queues, caches — through one interface. Starts, stops, and monitors them automatically. Built to eliminate onboarding friction and silent environment drift.

### Dropped
- "Instead of having to remember different commands for each service and manually check if they're running" — redundant with "one interface" and "automatically".
- "experienced developers were losing time" vs "new team members were spending too much time" — collapsed into "onboarding friction" and "environment drift", which covers both audiences without listing them separately.
