module TwitterClone
  module Schema
    extend self

    def setup
      Database.connection.exec <<-SQL
        CREATE TABLE IF NOT EXISTS tweets (
          id INTEGER PRIMARY KEY,
          display_name TEXT NOT NULL,
          username TEXT NOT NULL,
          body TEXT NOT NULL,
          likes_count INTEGER NOT NULL DEFAULT 0,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      SQL
    end
  end
end
