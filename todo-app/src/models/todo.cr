class Todo
  include DB::Serializable

  getter id : Int64?
  getter title : String
  getter details : String
  getter completed : Bool
  getter created_at : String
  getter updated_at : String

  def initialize(
    @title : String,
    @details : String = "",
    @completed : Bool = false,
    @id : Int64? = nil,
    @created_at : String = Time.utc.to_s,
    @updated_at : String = Time.utc.to_s,
  )
  end

  def completed? : Bool
    completed
  end

  def self.all : Array(Todo)
    TodoApp::Database.connection.query_all(
      "SELECT id, title, details, completed, created_at, updated_at FROM todos ORDER BY completed ASC, id DESC",
      as: Todo
    )
  end

  def self.find(id : Int64) : Todo?
    TodoApp::Database.connection.query_one?(
      "SELECT id, title, details, completed, created_at, updated_at FROM todos WHERE id = ?",
      id,
      as: Todo
    )
  end

  def self.create(title : String, details : String)
    now = Time.utc.to_s

    TodoApp::Database.connection.exec(
      "INSERT INTO todos (title, details, completed, created_at, updated_at) VALUES (?, ?, ?, ?, ?)",
      title,
      details,
      false,
      now,
      now
    )
  end

  def update(title : String, details : String, completed : Bool)
    return unless id

    TodoApp::Database.connection.exec(
      "UPDATE todos SET title = ?, details = ?, completed = ?, updated_at = ? WHERE id = ?",
      title,
      details,
      completed,
      Time.utc.to_s,
      id
    )
  end

  def toggle_completion
    return unless id

    TodoApp::Database.connection.exec(
      "UPDATE todos SET completed = ?, updated_at = ? WHERE id = ?",
      !completed?,
      Time.utc.to_s,
      id
    )
  end

  def delete
    return unless id

    TodoApp::Database.connection.exec(
      "DELETE FROM todos WHERE id = ?",
      id
    )
  end
end
