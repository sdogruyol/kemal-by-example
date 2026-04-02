# Webhook inbox

Accept HTTP POST webhooks at `/hooks/inbox`, authenticate them with **[kemal-hmac](https://github.com/kemalcr/kemal-hmac)** when `WEBHOOK_SECRET` is set (HMAC over client name, request path, and UTC timestamp), store the raw body and request headers in **SQLite**, and browse deliveries in the browser.

[kemal-hmac](https://github.com/kemalcr/kemal-hmac) is **not** registered unless `WEBHOOK_SECRET` is set: the middleware only loads when that variable is present, so there is no HMAC verification without a shared secret.

This is **not** the same protocol as GitHub’s `X-Hub-Signature-256` (body HMAC). [kemal-hmac](https://github.com/kemalcr/kemal-hmac) uses `hmac-client`, `hmac-timestamp`, and `hmac-token` headers; use `Kemal::Hmac::Client` or see `examples/send_webhook.cr`.

## Stack

- `Kemal`, [kemal-hmac](https://github.com/kemalcr/kemal-hmac), `SQLite`, `ECR`

## Environment

| Variable | Description |
|----------|-------------|
| `WEBHOOK_SECRET` | **Required** for [kemal-hmac](https://github.com/kemalcr/kemal-hmac): enables the HMAC middleware on `POST /hooks/inbox` and is the shared secret for `Kemal::Hmac::Client`. If unset, the app runs without HMAC (no kemal-hmac handler). |
| `HMAC_CLIENT_NAME` | Optional. Client id sent in `hmac-client` (default: `webhook`). Must match [kemal-hmac’s client name rules](https://github.com/kemalcr/kemal-hmac). |
| `DATABASE_URL` | Optional; defaults to `sqlite3:./db/webhook_inbox.db`. |

## Run

```bash
cd webhook-inbox
shards install
export WEBHOOK_SECRET=your_secret   # required for kemal-hmac on POST /hooks/inbox
crystal run src/webhook_inbox.cr
```

Open `http://127.0.0.1:3000` for the inbox UI.

## Send a test webhook

Use the same client name and secret as the server (default client `webhook`). Set `WEBHOOK_SECRET` in the shell to match the server.

```bash
export WEBHOOK_SECRET=your_secret
crystal run examples/send_webhook.cr
```

Or from Crystal code:

```crystal
require "kemal-hmac"
require "http/client"

client = Kemal::Hmac::Client.new("webhook", ENV["WEBHOOK_SECRET"])
path = "/hooks/inbox"
headers = HTTP::Headers.new
client.generate_headers(path).each { |k, v| headers.add(k, v) }
HTTP::Client.post("http://127.0.0.1:3000#{path}", headers: headers, body: %({"hello":"signed"}))
```

The token is derived from the **path** (`/hooks/inbox`), timestamp, and client name—use `generate_headers("/hooks/inbox")` for this route.

## Structure

- `src/webhook_inbox.cr` — entry, registers [kemal-hmac](https://github.com/kemalcr/kemal-hmac) when `WEBHOOK_SECRET` is set
- `src/middleware/inbox_hmac_handler.cr` — HMAC only for `POST /hooks/inbox`
- `src/routes/inbox.cr` — webhook endpoint
- `src/routes/home.cr` / `routes/events.cr` — inbox UI
- `examples/send_webhook.cr` — signed POST example
