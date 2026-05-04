require "./repo"

module BudgetManagementOrm
  module Schema
    extend self

    def setup
      Repo.raw_exec <<-SQL
        CREATE TABLE IF NOT EXISTS budget_entries (
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          kind TEXT NOT NULL,
          amount_cents INTEGER NOT NULL,
          notes TEXT NOT NULL DEFAULT '',
          created_at DATETIME,
          updated_at DATETIME
        );
      SQL
    end
  end
end
