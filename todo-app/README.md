# Todo App

Starter todo application built with `Kemal`, `SQLite`, and `ECR`.

## Stack

- Framework: `Kemal`
- Database: `SQLite`
- Language: `Crystal`

## Structure

- `src/todo_app.cr` - application entry point
- `src/config/database.cr` - database connection setup
- `src/config/schema.cr` - initial schema bootstrap
- `src/models/todo.cr` - todo model with CRUD methods
- `src/routes/home.cr` - root redirect
- `src/routes/todos.cr` - todo routes
- `src/views/` - ECR templates and layout
- `db/` - SQLite database files
- `public/` - static assets
- `spec/` - tests

## Features

- List todos
- Create a new todo
- Edit and update a todo
- Mark a todo as completed or pending
- Delete a todo

## Getting Started

1. Install dependencies:

   ```bash
   shards install
   ```

2. Run the app:

   ```bash
   crystal run src/todo_app.cr
   ```

3. Open `http://127.0.0.1:3000`
