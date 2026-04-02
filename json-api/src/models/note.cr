class Note
  include DB::Serializable

  getter id : Int64?
  getter title : String
  getter body : String
  getter created_at : String
  getter updated_at : String

  def initialize(
    @title : String,
    @body : String = "",
    @id : Int64? = nil,
    @created_at : String = Time.utc.to_s,
    @updated_at : String = Time.utc.to_s
  )
  end

  def self.all : Array(Note)
    JsonApi::Database.connection.query_all(
      "SELECT id, title, body, created_at, updated_at FROM notes ORDER BY id DESC",
      as: Note
    )
  end

  def self.find(id : Int64) : Note?
    JsonApi::Database.connection.query_one?(
      "SELECT id, title, body, created_at, updated_at FROM notes WHERE id = ?",
      id,
      as: Note
    )
  end

  def self.create(title : String, body : String) : Int64
    now = Time.utc.to_s
    db = JsonApi::Database.connection
    db.exec(
      "INSERT INTO notes (title, body, created_at, updated_at) VALUES (?, ?, ?, ?)",
      title,
      body,
      now,
      now
    )
    db.scalar("SELECT last_insert_rowid()").as(Int64)
  end

  def update(title : String, body : String)
    return unless id

    JsonApi::Database.connection.exec(
      "UPDATE notes SET title = ?, body = ?, updated_at = ? WHERE id = ?",
      title,
      body,
      Time.utc.to_s,
      id
    )
  end

  def delete
    return unless id

    JsonApi::Database.connection.exec(
      "DELETE FROM notes WHERE id = ?",
      id
    )
  end

  def to_h
    {
      "id"         => id,
      "title"      => title,
      "body"       => body,
      "created_at" => created_at,
      "updated_at" => updated_at,
    }
  end
end
