class User
  include DB::Serializable

  getter id : Int64?
  getter github_id : Int64
  getter login : String
  getter name : String
  getter avatar_url : String
  getter email : String?
  getter created_at : String
  getter updated_at : String

  def initialize(
    @github_id : Int64,
    @login : String,
    @name : String,
    @avatar_url : String,
    @email : String? = nil,
    @id : Int64? = nil,
    @created_at : String = Time.utc.to_s,
    @updated_at : String = Time.utc.to_s,
  )
  end

  def self.find(id : Int64) : User?
    OauthLogin::Database.connection.query_one?(
      "SELECT id, github_id, login, name, avatar_url, email, created_at, updated_at FROM users WHERE id = ?",
      id,
      as: User
    )
  end

  def self.find_by_github_id(github_id : Int64) : User?
    OauthLogin::Database.connection.query_one?(
      "SELECT id, github_id, login, name, avatar_url, email, created_at, updated_at FROM users WHERE github_id = ?",
      github_id,
      as: User
    )
  end

  def self.upsert_from_github(github_id : Int64, login : String, name : String, avatar_url : String, email : String?) : User
    now = Time.utc.to_s
    existing = find_by_github_id(github_id)
    if existing
      uid = existing.id.not_nil!
      OauthLogin::Database.connection.exec(
        "UPDATE users SET login = ?, name = ?, avatar_url = ?, email = ?, updated_at = ? WHERE id = ?",
        login,
        name,
        avatar_url,
        email,
        now,
        uid
      )
      find(uid).not_nil!
    else
      OauthLogin::Database.connection.exec(
        "INSERT INTO users (github_id, login, name, avatar_url, email, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)",
        github_id,
        login,
        name,
        avatar_url,
        email,
        now,
        now
      )
      db = OauthLogin::Database.connection
      new_id = db.scalar("SELECT last_insert_rowid()").as(Int64)
      find(new_id).not_nil!
    end
  end
end
