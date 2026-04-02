require "digest/sha256"

class User
  include DB::Serializable

  getter id : Int64?
  getter name : String
  getter email : String
  getter password_hash : String
  getter created_at : String
  getter updated_at : String

  def initialize(
    @name : String,
    @email : String,
    @password_hash : String,
    @id : Int64? = nil,
    @created_at : String = Time.utc.to_s,
    @updated_at : String = Time.utc.to_s,
  )
  end

  def self.find(id : Int64) : User?
    Ecommerce::Database.connection.query_one?(
      "SELECT id, name, email, password_hash, created_at, updated_at FROM users WHERE id = ?",
      id,
      as: User
    )
  end

  def self.find_by_email(email : String) : User?
    Ecommerce::Database.connection.query_one?(
      "SELECT id, name, email, password_hash, created_at, updated_at FROM users WHERE email = ?",
      normalize_email(email),
      as: User
    )
  end

  def self.create(name : String, email : String, password : String) : User
    now = Time.utc.to_s
    normalized_email = normalize_email(email)
    password_hash = Digest::SHA256.hexdigest(password)

    Ecommerce::Database.connection.exec(
      "INSERT INTO users (name, email, password_hash, created_at, updated_at) VALUES (?, ?, ?, ?, ?)",
      name,
      normalized_email,
      password_hash,
      now,
      now
    )

    find_by_email(normalized_email).not_nil!
  end

  def self.authenticate(email : String, password : String) : User?
    user = find_by_email(email)
    return unless user

    return user if user.password_hash == Digest::SHA256.hexdigest(password)
  end

  def self.normalize_email(value : String) : String
    value.strip.downcase
  end
end
