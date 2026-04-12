### Before
Never commit files that contain API keys, tokens, passwords, or any other secrets. If you notice a .env file, credentials.json, or similar sensitive file is staged, warn the user immediately and remove it from staging. When generating example configuration files, always use placeholder values like YOUR_API_KEY_HERE rather than inventing realistic-looking fake keys, because realistic fakes can cause confusion about whether real credentials were leaked.

### After
Never commit secrets. If .env, credentials.json, or similar files are staged, warn and unstage immediately. In example configs, use obvious placeholders (YOUR_API_KEY_HERE) — realistic-looking fakes risk being mistaken for real leaks.

### Source
Raw distillation. No philosophical principle maps precisely to secret hygiene rules with placeholder formatting constraints.

### Dropped
Nothing. All constraints preserved: the ban on committing secrets, the warn-and-unstage action for sensitive files, the placeholder requirement, and the rationale for avoiding realistic fakes.
