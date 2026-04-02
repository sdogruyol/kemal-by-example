# Kemal By Example

This repository collects example applications built with `Kemal`, with a focus on clarity, simplicity, and practical full-stack patterns.

`Kemal` stands out by making web development feel lightweight without sacrificing capability. It is easy to read, fast to iterate on, and powerful enough to support real application structure with clean routes, server-rendered pages, straightforward organization, and approachable WebSocket support for realtime features. The goal of this repository is to explore that balance through multiple hands-on projects.

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
- `Real-time Dashboard` - A live monitoring panel for CPU and memory metrics, built with `Kemal`, `SQLite`, `ECR`, `WebSockets`, and Crystal concurrency.
- `Twitter clone` - A lightweight social timeline with realtime updates, built with `Kemal`, `SQLite`, `ECR`, and `WebSockets`.
- `Todo app` - A simple task manager with full todo CRUD, built with `Kemal`, `SQLite`, and `ECR`.
- `URL shortener` - A compact link shortener with redirect tracking, built with `Kemal`, `SQLite`, and `ECR`.

## Directory Structure

- `blog/`
- `ecommerce/`
- `file-upload-storage/`
- `real-time-dashboard/`
- `twitter-clone/`
- `todo-app/`
- `url-shortener/`

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

### Real-time Dashboard

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

### Twitter Clone

```bash
cd twitter-clone
shards install
crystal run src/twitter_clone.cr
```

Then open `http://127.0.0.1:3000`.
