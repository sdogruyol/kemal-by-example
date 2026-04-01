class Post
  include DB::Serializable

  getter id : Int64?
  getter title : String
  getter body : String
  getter created_at : String
  getter updated_at : String

  def initialize(
    @title : String,
    @body : String,
    @id : Int64? = nil,
    @created_at : String = Time.utc.to_s,
    @updated_at : String = Time.utc.to_s
  )
  end

  def self.all : Array(Post)
    Blog::Database.connection.query_all(
      "SELECT id, title, body, created_at, updated_at FROM posts ORDER BY id DESC",
      as: Post
    )
  end

  def self.find(id : Int64) : Post?
    Blog::Database.connection.query_one?(
      "SELECT id, title, body, created_at, updated_at FROM posts WHERE id = ?",
      id,
      as: Post
    )
  end

  def self.create(title : String, body : String)
    now = Time.utc.to_s

    Blog::Database.connection.exec(
      "INSERT INTO posts (title, body, created_at, updated_at) VALUES (?, ?, ?, ?)",
      title,
      body,
      now,
      now
    )
  end

  def update(title : String, body : String)
    return unless id

    Blog::Database.connection.exec(
      "UPDATE posts SET title = ?, body = ?, updated_at = ? WHERE id = ?",
      title,
      body,
      Time.utc.to_s,
      id
    )
  end

  def delete
    return unless id

    Blog::Database.connection.exec(
      "DELETE FROM posts WHERE id = ?",
      id
    )
  end
end
