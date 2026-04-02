class StoredFile
  include DB::Serializable

  getter id : Int64?
  getter original_name : String
  getter stored_name : String
  getter mime_type : String
  getter size_bytes : Int64
  getter created_at : String

  def initialize(
    @original_name : String,
    @stored_name : String,
    @mime_type : String,
    @size_bytes : Int64,
    @created_at : String = Time.local.to_s("%Y-%m-%d %H:%M:%S"),
    @id : Int64? = nil
  )
  end

  def self.all : Array(StoredFile)
    FileUploadStorage::Database.connection.query_all(
      "SELECT id, original_name, stored_name, mime_type, size_bytes, created_at FROM stored_files ORDER BY id DESC",
      as: StoredFile
    )
  end

  def self.find(id : Int64) : StoredFile?
    FileUploadStorage::Database.connection.query_one?(
      "SELECT id, original_name, stored_name, mime_type, size_bytes, created_at FROM stored_files WHERE id = ?",
      id,
      as: StoredFile
    )
  end

  def self.create(original_name : String, stored_name : String, mime_type : String, size_bytes : Int64) : StoredFile
    created_at = Time.local.to_s("%Y-%m-%d %H:%M:%S")

    FileUploadStorage::Database.connection.exec(
      "INSERT INTO stored_files (original_name, stored_name, mime_type, size_bytes, created_at) VALUES (?, ?, ?, ?, ?)",
      original_name,
      stored_name,
      mime_type,
      size_bytes,
      created_at
    )

    id = FileUploadStorage::Database.connection.query_one(
      "SELECT last_insert_rowid()",
      as: Int64
    )

    find(id).not_nil!
  end

  def public_path : String
    "/uploads/#{stored_name}"
  end

  def storage_path : String
    ::File.join(Kemal.config.public_folder, "uploads", stored_name)
  end

  def image? : Bool
    mime_type.starts_with?("image/")
  end

  def formatted_size : String
    bytes = size_bytes.to_f64
    return "#{size_bytes} B" if bytes < 1024
    return "#{(bytes / 1024).round(2)} KB" if bytes < 1024 * 1024

    "#{(bytes / (1024 * 1024)).round(2)} MB"
  end

  def delete
    return unless id

    FileUploadStorage::Database.connection.exec(
      "DELETE FROM stored_files WHERE id = ?",
      id
    )
  end

  def self.allowed_extension?(filename : String) : Bool
    allowed_extensions.includes?(::File.extname(filename).downcase)
  end

  def self.allowed_extensions : Array(String)
    [".jpg", ".jpeg", ".png", ".gif", ".webp", ".pdf", ".txt"]
  end
end
