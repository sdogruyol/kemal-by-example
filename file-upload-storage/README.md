# File Upload & Storage

A compact file manager built with `Kemal`, `SQLite`, and `ECR`.

## Stack

- Framework: `Kemal`
- Database: `SQLite`
- Templating: `ECR`
- Language: `Crystal`

## Structure

- `src/file_upload_storage.cr` - application entry point
- `src/config/database.cr` - database connection setup
- `src/config/schema.cr` - initial schema bootstrap
- `src/models/stored_file.cr` - file metadata model and helpers
- `src/routes/home.cr` - root redirect
- `src/routes/files.cr` - upload, listing, details, and delete routes
- `src/views/` - ECR templates and layout
- `public/uploads/` - uploaded file storage
- `db/` - SQLite database files
- `spec/` - tests

## Features

- Upload files with multipart form handling
- Store file metadata in `SQLite`
- Serve uploaded files from the public folder
- List uploaded files with metadata
- View and delete stored files

## Getting Started

1. Install dependencies:

   ```bash
   shards install
   ```

2. Run the app:

   ```bash
   crystal run src/file_upload_storage.cr
   ```

3. Open `http://127.0.0.1:3000`
