# Blog

Starter blog application built with `Kemal`, `SQLite`, and `ECR`.

## Stack

- Framework: `Kemal`
- Database: `SQLite`
- Language: `Crystal`

## Structure

- `src/blog.cr` - application entry point
- `src/config/database.cr` - database connection setup
- `src/config/schema.cr` - initial schema bootstrap
- `src/models/post.cr` - post model with CRUD methods
- `src/routes/home.cr` - root redirect
- `src/routes/posts.cr` - post routes
- `src/views/` - ECR templates and layout
- `db/` - SQLite database files
- `public/` - static assets
- `spec/` - tests

## Features

- List blog posts
- Create a new post
- Edit and update a post
- Delete a post

## Getting Started

1. Install dependencies:

   ```bash
   shards install
   ```

2. Run the app:

   ```bash
   crystal run src/blog.cr
   ```

3. Open `http://127.0.0.1:3000`
