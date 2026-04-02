module OauthLogin
  module Schema
    extend self

    def setup
      Database.connection.exec <<-SQL
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY,
          github_id INTEGER NOT NULL UNIQUE,
          login TEXT NOT NULL,
          name TEXT NOT NULL DEFAULT '',
          avatar_url TEXT NOT NULL DEFAULT '',
          email TEXT,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      SQL
    end
  end
end
