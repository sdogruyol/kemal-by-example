# Real-time Dashboard

A live system monitoring dashboard built with `Kemal`, `SQLite`, `ECR`, and WebSockets.

## Stack

- Framework: `Kemal`
- Database: `SQLite`
- Templating: `ECR`
- Realtime transport: `WebSocket`
- Language: `Crystal`

## Why It Matters

This project is designed to highlight one of Crystal's biggest strengths: concurrency. It uses concurrent fibers to collect system metrics, a `Channel` to pass data through the pipeline, and WebSockets to stream updates into the browser in real time.

## Structure

- `src/real_time_dashboard.cr` - application entry point
- `src/config/database.cr` - database connection setup
- `src/config/schema.cr` - initial schema bootstrap
- `src/models/metric_snapshot.cr` - persisted metric samples
- `src/services/system_metrics.cr` - CPU and memory metric collection
- `src/services/metrics_hub.cr` - concurrent sampling and WebSocket broadcasting
- `src/routes/home.cr` - root redirect
- `src/routes/dashboard.cr` - dashboard page and socket routes
- `src/views/` - ECR templates and layout
- `public/js/dashboard.js` - realtime dashboard client logic
- `db/` - SQLite database files
- `spec/` - tests

## Features

- Live CPU and memory usage metrics
- Concurrent metric collection with Crystal fibers
- WebSocket broadcasting to connected clients
- Lightweight browser-based charts
- Short history persisted in SQLite

## Getting Started

1. Install dependencies:

   ```bash
   shards install
   ```

2. Run the app:

   ```bash
   crystal run src/real_time_dashboard.cr
   ```

3. Open `http://127.0.0.1:3000`
