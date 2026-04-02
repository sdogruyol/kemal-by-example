module FileUploadStorage
  module Database
    extend self

    DATABASE_URL = ENV["DATABASE_URL"]? || "sqlite3:./db/file_upload_storage.db"

    @@connection : DB::Database? = nil

    def connection : DB::Database
      @@connection ||= DB.open(DATABASE_URL)
    end
  end
end
