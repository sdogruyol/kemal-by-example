# URL Shortener

A compact URL shortener built with `Kemal`, `SQLite`, and `ECR`.

## Stack

- Framework: `Kemal`
- Database: `SQLite`
- Templating: `ECR`
- Language: `Crystal`

## Structure

- `src/url_shortener.cr` - application entry point
- `src/config/database.cr` - database connection setup
- `src/config/schema.cr` - initial schema bootstrap
- `src/models/short_url.cr` - short URL model and redirect logic
- `src/routes/home.cr` - root redirect
- `src/routes/short_urls.cr` - management and redirect routes
- `src/views/` - ECR templates and layout
- `db/` - SQLite database files
- `public/` - static assets
- `spec/` - tests

## Features

- Create short URLs
- List saved links
- Redirect from short code to original URL
- Track click counts
- Edit and delete existing short URLs

## Getting Started

1. Install dependencies:

   ```bash
   shards install
   ```

2. Run the app:

   ```bash
   crystal run src/url_shortener.cr
   ```

3. Open `http://127.0.0.1:3000`
