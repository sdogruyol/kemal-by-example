module FileUploadStorage
  module Schema
    extend self

    def setup
      Database.connection.exec <<-SQL
        CREATE TABLE IF NOT EXISTS stored_files (
          id INTEGER PRIMARY KEY,
          original_name TEXT NOT NULL,
          stored_name TEXT NOT NULL UNIQUE,
          mime_type TEXT NOT NULL,
          size_bytes INTEGER NOT NULL,
          created_at TEXT NOT NULL
        )
      SQL
    end
  end
end
