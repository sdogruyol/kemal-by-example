# Budget management (Crecto ORM)

Small web UI for tracking income and expenses with **Kemal**, **SQLite**, and **[Crecto](https://github.com/Crecto/crecto)** as the ORM.

## Stack

- Framework: `Kemal`
- ORM: `Crecto`
- Database: `SQLite`
- Templates: `ECR`

## Layout

- `src/budget_management_orm.cr` — entry point
- `src/config/repo.cr` — Crecto repo (SQLite file path)
- `src/config/schema.cr` — `budget_entries` table bootstrap
- `src/models/budget_entry.cr` — model, validations, queries
- `src/lib/money.cr` — parse/format amounts in cents
- `src/routes/` — HTTP routes
- `src/views/` — HTML templates
- `db/` — SQLite file (default `budget_management.db`)

## Run

```bash
cd budget-management-orm
shards install
crystal run src/budget_management_orm.cr
```

Open `http://127.0.0.1:3000`.

Optional: `BUDGET_DATABASE=/path/to/file.db` selects the SQLite file.

## Features

- Summary: total income, total expenses, balance
- Add ledger entries (title, type, amount, notes)
- Edit and delete entries
- Amounts stored as integer cents in the database
