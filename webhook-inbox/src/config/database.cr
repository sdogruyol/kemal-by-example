module WebhookInbox
  module Database
    extend self

    DATABASE_URL = ENV["DATABASE_URL"]? || "sqlite3:./db/webhook_inbox.db"

    @@connection : DB::Database? = nil

    def connection : DB::Database
      @@connection ||= DB.open(DATABASE_URL)
    end
  end
end
