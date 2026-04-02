module RealTimeDashboard
  module Database
    extend self

    DATABASE_URL = ENV["DATABASE_URL"]? || "sqlite3:./db/real_time_dashboard.db"

    @@connection : DB::Database? = nil

    def connection : DB::Database
      @@connection ||= DB.open(DATABASE_URL)
    end
  end
end
