# E-commerce

A small e-commerce example built with `Kemal`, `SQLite`, and `ECR`.

## Stack

- Framework: `Kemal`
- Database: `SQLite`
- Templating: `ECR`
- Language: `Crystal`

## Features

- User signup and login
- Product listing with seeded sample inventory
- Add to cart and quantity updates
- Remove items from cart
- Simple checkout flow

## Getting Started

1. Install dependencies:

   ```bash
   shards install
   ```

2. Run the app:

   ```bash
   crystal run src/ecommerce.cr
   ```

3. Open `http://127.0.0.1:3000`
