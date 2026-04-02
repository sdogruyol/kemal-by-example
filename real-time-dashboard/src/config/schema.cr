module RealTimeDashboard
  module Schema
    extend self

    def setup
      Database.connection.exec <<-SQL
        CREATE TABLE IF NOT EXISTS metric_snapshots (
          id INTEGER PRIMARY KEY,
          cpu_percent REAL NOT NULL,
          memory_percent REAL NOT NULL,
          created_at TEXT NOT NULL
        )
      SQL
    end
  end
end
