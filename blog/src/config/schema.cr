module Blog
  module Schema
    extend self

    def setup
      Database.connection.exec <<-SQL
        CREATE TABLE IF NOT EXISTS posts (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          body TEXT NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      SQL
    end
  end
end
