# Kemal By Example

This repository collects example applications built with `Kemal`, with a focus on clarity, simplicity, and practical full-stack patterns.

`Kemal` stands out by making web development feel lightweight without sacrificing capability. It is easy to read, fast to iterate on, and powerful enough to support real application structure with clean routes, server-rendered pages, and straightforward organization. The goal of this repository is to explore that balance through multiple hands-on projects.

## Shared Stack

- Web framework: `Kemal`
- Database: `SQLite`
- Templating: `ECR` for server-rendered HTML
- Language: `Crystal`

## Why This Repository

- Showcase the simplicity of building web apps with `Kemal`
- Demonstrate a small and effective stack built around `Kemal`, `SQLite`, and `ECR`
- Provide practical example projects instead of isolated snippets
- Keep each application easy to read, extend, and learn from

## Completed Projects

- Blog
- E-commerce
- Real-time Dashboard
- Twitter clone
- Todo app
- URL shortener

## Directory Structure

- `blog/`
- `ecommerce/`
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
