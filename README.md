# Kemal By Example

This repository collects practical projects built with [`Kemal`](https://kemalcr.com/), designed to show how productive, readable, and capable the framework can be in real applications.

[`Kemal`](https://kemalcr.com/) stands out by making web development feel lightweight without sacrificing capability. It is easy to read, fast to iterate on, and powerful enough to support clean routes, server-rendered pages, straightforward project organization, sessions, file uploads, and realtime features with WebSockets. The goal of this repository is to present practical projects that show and demonstrate the power of Kemal through hands-on examples.

## Shared Stack

- Web framework: `Kemal`
- Database: `SQLite`
- Templating: `ECR` for server-rendered HTML
- Realtime transport: `WebSockets` where realtime features are needed
- Language: `Crystal`

## Why This Repository

- Showcase the simplicity of building web apps with `Kemal`
- Demonstrate a small and effective stack built around `Kemal`, `SQLite`, `ECR`, and `WebSockets`
- Provide practical example projects instead of isolated snippets
- Keep each application easy to read, extend, and learn from

## Projects

- `Blog` - A server-rendered blog with post CRUD, built with `Kemal`, `SQLite`, and `ECR`.
- `E-commerce` - A small storefront with authentication and cart flow, built with `Kemal`, `SQLite`, `ECR`, and `kemal-session`.
- `File Upload & Storage` - A multipart upload manager with public file serving and metadata storage, built with `Kemal`, `SQLite`, and `ECR`.
- `Todo app` - A simple task manager with full todo CRUD, built with `Kemal`, `SQLite`, and `ECR`.
- `URL shortener` - A compact link shortener with redirect tracking, built with `Kemal`, `SQLite`, and `ECR`.
- `JSON API` - A REST JSON API for notes (`GET`/`POST`/`PUT`/`PATCH`/`DELETE` under `/api/notes`), built with `Kemal`, `SQLite`, and Crystal’s `JSON` module.
- `OAuth login` - GitHub OAuth2 sign-in with session-backed user records, built with `Kemal`, `SQLite`, `ECR`, and `kemal-session`.
- `Webhook inbox` - Inbound webhook receiver using [kemal-hmac](https://github.com/kemalcr/kemal-hmac) when `WEBHOOK_SECRET` is set, plus a small inbox UI, built with `Kemal`, `SQLite`, and `ECR`.

## Realtime Projects (`WebSockets`)

- `Real-time Dashboard` - A live monitoring panel for CPU and memory metrics, built with `Kemal`, `SQLite`, `ECR`, `WebSockets`, and Crystal concurrency.
- `Twitter clone` - A lightweight Twitter clone with realtime updates, built with `Kemal`, `SQLite`, `ECR`, and `WebSockets`.

## Directory Structure

- `blog/`
- `ecommerce/`
- `file-upload-storage/`
- `real-time-dashboard/`
- `twitter-clone/`
- `todo-app/`
- `url-shortener/`
- `json-api/`
- `oauth-login/`
- `webhook-inbox/`

## Getting Started

Clone the repository first:

```bash
git clone https://github.com/sdogruyol/kemal-by-example
cd kemal-by-example
```

Then choose one of the example applications below and run it from its own directory.

## Running The Projects

Each project is self-contained. Open a terminal, move into the project directory, install dependencies, and run the app with Crystal.

### Blog

```bash
cd blog
shards install
crystal run src/blog.cr
```

Then open `http://127.0.0.1:3000`.

### E-commerce

```bash
cd ecommerce
shards install
crystal run src/ecommerce.cr
```

Then open `http://127.0.0.1:3000`.

### File Upload & Storage

```bash
cd file-upload-storage
shards install
crystal run src/file_upload_storage.cr
```

Then open `http://127.0.0.1:3000`.

### Real-time Dashboard (`WebSockets`)

```bash
cd real-time-dashboard
shards install
crystal run src/real_time_dashboard.cr
```

Then open `http://127.0.0.1:3000`.

### Todo App

```bash
cd todo-app
shards install
crystal run src/todo_app.cr
```

Then open `http://127.0.0.1:3000`.

### URL Shortener

```bash
cd url-shortener
shards install
crystal run src/url_shortener.cr
```

Then open `http://127.0.0.1:3000`.

### JSON API

```bash
cd json-api
shards install
crystal run src/json_api.cr
```

Then open `http://127.0.0.1:3000` or call `http://127.0.0.1:3000/api/notes`.

### OAuth login

```bash
cd oauth-login
shards install
crystal run src/oauth_login.cr
```

Configure a [GitHub OAuth App](https://github.com/settings/developers) and set `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET`. See `oauth-login/README.md`.

### Webhook inbox

```bash
cd webhook-inbox
shards install
export WEBHOOK_SECRET=your_secret
crystal run src/webhook_inbox.cr
```

Then open `http://127.0.0.1:3000`. Signed POSTs to `/hooks/inbox` use [kemal-hmac](https://github.com/kemalcr/kemal-hmac); see `webhook-inbox/README.md`.

### Twitter Clone (`WebSockets`)

```bash
cd twitter-clone
shards install
crystal run src/twitter_clone.cr
```

Then open `http://127.0.0.1:3000`.
