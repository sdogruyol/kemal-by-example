# JSON API

REST-style JSON API for notes, built with `Kemal`, `SQLite`, and Crystal’s `JSON` module. All responses use `Content-Type: application/json` except `204 No Content` on successful delete.

## Stack

- Framework: `Kemal`
- Database: `SQLite`
- Language: `Crystal`

## Structure

- `src/json_api.cr` — application entry point
- `src/config/database.cr` — database connection
- `src/config/schema.cr` — schema bootstrap
- `src/models/note.cr` — note model and CRUD
- `src/helpers/json_response.cr` — JSON response helpers
- `src/routes/home.cr` — JSON discovery document at `/`
- `src/routes/api.cr` — `/api/notes` REST routes
- `db/` — SQLite database files

## API

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/` | API metadata and endpoint list |
| `GET` | `/api/notes` | List notes |
| `GET` | `/api/notes/:id` | One note |
| `POST` | `/api/notes` | Create (`{"title":"...","body":"..."}`) |
| `PUT` | `/api/notes/:id` | Full replace (`title` required) |
| `PATCH` | `/api/notes/:id` | Partial update (`title` / `body` optional) |
| `DELETE` | `/api/notes/:id` | Delete |

## Getting Started

1. Install dependencies:

   ```bash
   shards install
   ```

2. Run the app:

   ```bash
   crystal run src/json_api.cr
   ```

3. Open `http://127.0.0.1:3000` or call `http://127.0.0.1:3000/api/notes` with `curl` or any HTTP client.

## Example

```bash
curl -s -X POST http://127.0.0.1:3000/api/notes \
  -H 'Content-Type: application/json' \
  -d '{"title":"First note","body":"Optional body"}'
```
