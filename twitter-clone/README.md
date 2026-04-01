# Twitter Clone

A lightweight Twitter-style timeline built with `Kemal`, `SQLite`, and `ECR`.

## Stack

- Framework: `Kemal`
- Database: `SQLite`
- Templating: `ECR`
- Language: `Crystal`

## Structure

- `src/twitter_clone.cr` - application entry point
- `src/config/database.cr` - database connection setup
- `src/config/schema.cr` - initial schema bootstrap
- `src/models/tweet.cr` - tweet model with timeline actions
- `src/routes/home.cr` - root redirect
- `src/routes/tweets.cr` - timeline and tweet routes
- `src/views/` - ECR templates and layout
- `db/` - SQLite database files
- `public/` - static assets
- `spec/` - tests

## Features

- Post tweets to a shared timeline
- List tweets in reverse chronological order
- Edit and delete existing tweets
- Like tweets
- Normalize usernames into a handle format

## Getting Started

1. Install dependencies:

   ```bash
   shards install
   ```

2. Run the app:

   ```bash
   crystal run src/twitter_clone.cr
   ```

3. Open `http://127.0.0.1:3000`
