module WebhookInbox
  module Schema
    extend self

    def setup
      Database.connection.exec <<-SQL
        CREATE TABLE IF NOT EXISTS webhook_events (
          id INTEGER PRIMARY KEY,
          created_at TEXT NOT NULL,
          content_type TEXT NOT NULL DEFAULT '',
          body TEXT NOT NULL,
          headers_json TEXT NOT NULL,
          signature_status TEXT NOT NULL
        )
      SQL
    end
  end
end
