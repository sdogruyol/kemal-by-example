class Tweet
  include DB::Serializable

  getter id : Int64?
  getter display_name : String
  getter username : String
  getter body : String
  getter likes_count : Int64
  getter created_at : String
  getter updated_at : String

  def initialize(
    @display_name : String,
    @username : String,
    @body : String,
    @likes_count : Int64 = 0_i64,
    @id : Int64? = nil,
    @created_at : String = Time.utc.to_s,
    @updated_at : String = Time.utc.to_s,
  )
  end

  def self.all : Array(Tweet)
    TwitterClone::Database.connection.query_all(
      "SELECT id, display_name, username, body, likes_count, created_at, updated_at FROM tweets ORDER BY id DESC",
      as: Tweet
    )
  end

  def self.find(id : Int64) : Tweet?
    TwitterClone::Database.connection.query_one?(
      "SELECT id, display_name, username, body, likes_count, created_at, updated_at FROM tweets WHERE id = ?",
      id,
      as: Tweet
    )
  end

  def self.create(display_name : String, username : String, body : String) : Tweet
    now = Time.utc.to_s

    TwitterClone::Database.connection.exec(
      "INSERT INTO tweets (display_name, username, body, likes_count, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)",
      display_name,
      normalize_username(username),
      body,
      0_i64,
      now,
      now
    )

    id = TwitterClone::Database.connection.query_one(
      "SELECT last_insert_rowid()",
      as: Int64
    )

    find(id).not_nil!
  end

  def update(display_name : String, username : String, body : String) : Tweet?
    tweet_id = id
    return unless tweet_id

    TwitterClone::Database.connection.exec(
      "UPDATE tweets SET display_name = ?, username = ?, body = ?, updated_at = ? WHERE id = ?",
      display_name,
      self.class.normalize_username(username),
      body,
      Time.utc.to_s,
      tweet_id
    )

    self.class.find(tweet_id)
  end

  def like : Tweet?
    tweet_id = id
    return unless tweet_id

    TwitterClone::Database.connection.exec(
      "UPDATE tweets SET likes_count = likes_count + 1, updated_at = ? WHERE id = ?",
      Time.utc.to_s,
      tweet_id
    )

    self.class.find(tweet_id)
  end

  def delete : Int64?
    tweet_id = id
    return unless tweet_id

    TwitterClone::Database.connection.exec(
      "DELETE FROM tweets WHERE id = ?",
      tweet_id
    )

    tweet_id
  end

  def handle : String
    "@#{username}"
  end

  def self.normalize_username(value : String) : String
    value.strip.downcase.gsub(/^@+/, "")
  end
end
