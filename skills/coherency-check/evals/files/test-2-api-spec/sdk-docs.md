# JavaScript SDK Documentation

## Installation

```bash
npm install @taskflow/sdk
```

## Authentication

```javascript
const client = new TaskFlow({
  apiKey: 'your-api-key',
  baseUrl: 'https://api.taskflow.io/v1'
});

// Login
const { token } = await client.auth.login(email, password);
// Token is valid for 24 hours
```

## Users

```javascript
// Get current user
const user = await client.users.me();

// Update profile
await client.users.update({ name: 'New Name', email: 'new@example.com' });

// Delete account — permanent and immediate, cannot be undone
await client.users.delete();
```

## Projects

```javascript
// List projects (paginated)
const projects = await client.projects.list({ page: 1, perPage: 25 });
// Max 100 per page

// Create project
const project = await client.projects.create({
  name: 'My Project',
  description: 'Optional description',
  color: '#FF5733'  // Optional, accepts any CSS color value
});
// Free tier: unlimited projects
```

## Error Handling

All methods throw `TaskFlowError` with a `code` and `message`. Common codes:

- `auth/invalid-credentials` — wrong email or password
- `auth/rate-limited` — too many login attempts (max 10 per minute)
- `auth/email-not-verified` — login attempted before email verification
