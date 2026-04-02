# OAuth login

Sign in with **GitHub** using the OAuth2 authorization code flow: redirect to GitHub, callback with `code`, exchange for an access token, load the user profile, then store a row in SQLite and keep `user_id` in `kemal-session`.

## Stack

- `Kemal`, `kemal-session`, `SQLite`, `ECR`

## GitHub OAuth App

1. Open GitHub → **Settings** → **Developer settings** → **OAuth Apps** → **New OAuth App**.
2. Set **Application name** as you like.
3. **Homepage URL:** `http://127.0.0.1:3000`
4. **Authorization callback URL:** `http://127.0.0.1:3000/auth/github/callback`  
   (or match `OAUTH_REDIRECT_URI` if you override it.)
5. Create the app, then copy the **Client ID** and generate a **Client secret**.

## Environment

| Variable | Required | Description |
|----------|----------|-------------|
| `GITHUB_CLIENT_ID` | Yes | OAuth App client ID |
| `GITHUB_CLIENT_SECRET` | Yes | OAuth App client secret |
| `OAUTH_REDIRECT_URI` | No | Defaults to `http://127.0.0.1:3000/auth/github/callback` |
| `KEMAL_SESSION_SECRET` | No | Session signing secret (set in production) |
| `DATABASE_URL` | No | Defaults to `sqlite3:./db/oauth_login.db` |

Example:

```bash
export GITHUB_CLIENT_ID="your_id"
export GITHUB_CLIENT_SECRET="your_secret"
```

## Run

```bash
cd oauth-login
shards install
crystal run src/oauth_login.cr
```

Open `http://127.0.0.1:3000` and use **Sign in with GitHub**.

## Structure

- `src/oauth_login.cr` — entry, session config
- `src/services/github_oauth.cr` — authorize URL, token exchange, GitHub API
- `src/routes/oauth.cr` — `/auth/github`, `/auth/github/callback`, `POST /logout`
- `src/models/user.cr` — `users` keyed by `github_id`

CSRF protection uses a random `state` stored in the session and compared on callback.
