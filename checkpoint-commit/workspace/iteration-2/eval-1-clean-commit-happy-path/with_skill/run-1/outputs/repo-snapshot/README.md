# auth-service

Small authentication service used for eval testing.

## Endpoints

- `POST /login` — issue a session token for valid credentials.
- `POST /refresh` — exchange a valid refresh token for a new access token.
