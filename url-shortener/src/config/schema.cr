module UrlShortener
  module Schema
    extend self

    def setup
      Database.connection.exec <<-SQL
        CREATE TABLE IF NOT EXISTS short_urls (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL DEFAULT '',
          original_url TEXT NOT NULL,
          short_code TEXT NOT NULL UNIQUE,
          click_count INTEGER NOT NULL DEFAULT 0,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      SQL
    end
  end
end
