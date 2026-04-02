require "random/secure"

class ShortUrl
  include DB::Serializable

  getter id : Int64?
  getter title : String
  getter original_url : String
  getter short_code : String
  getter click_count : Int64
  getter created_at : String
  getter updated_at : String

  def initialize(
    @original_url : String,
    @short_code : String,
    @title : String = "",
    @click_count : Int64 = 0_i64,
    @id : Int64? = nil,
    @created_at : String = Time.utc.to_s,
    @updated_at : String = Time.utc.to_s,
  )
  end

  def self.all : Array(ShortUrl)
    UrlShortener::Database.connection.query_all(
      "SELECT id, title, original_url, short_code, click_count, created_at, updated_at FROM short_urls ORDER BY id DESC",
      as: ShortUrl
    )
  end

  def self.find(id : Int64) : ShortUrl?
    UrlShortener::Database.connection.query_one?(
      "SELECT id, title, original_url, short_code, click_count, created_at, updated_at FROM short_urls WHERE id = ?",
      id,
      as: ShortUrl
    )
  end

  def self.find_by_short_code(short_code : String) : ShortUrl?
    UrlShortener::Database.connection.query_one?(
      "SELECT id, title, original_url, short_code, click_count, created_at, updated_at FROM short_urls WHERE short_code = ?",
      short_code,
      as: ShortUrl
    )
  end

  def self.create(original_url : String, title : String = "")
    now = Time.utc.to_s
    short_code = generate_unique_short_code

    UrlShortener::Database.connection.exec(
      "INSERT INTO short_urls (title, original_url, short_code, click_count, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)",
      title,
      normalize_url(original_url),
      short_code,
      0_i64,
      now,
      now
    )
  end

  def update(title : String, original_url : String)
    return unless id

    UrlShortener::Database.connection.exec(
      "UPDATE short_urls SET title = ?, original_url = ?, updated_at = ? WHERE id = ?",
      title,
      self.class.normalize_url(original_url),
      Time.utc.to_s,
      id
    )
  end

  def register_click
    return unless id

    UrlShortener::Database.connection.exec(
      "UPDATE short_urls SET click_count = click_count + 1, updated_at = ? WHERE id = ?",
      Time.utc.to_s,
      id
    )
  end

  def delete
    return unless id

    UrlShortener::Database.connection.exec(
      "DELETE FROM short_urls WHERE id = ?",
      id
    )
  end

  def display_title : String
    return title unless title.empty?

    original_url
  end

  def self.normalize_url(url : String) : String
    value = url.strip

    return value if value.starts_with?("http://") || value.starts_with?("https://")

    "https://#{value}"
  end

  private def self.generate_unique_short_code : String
    loop do
      short_code = Random::Secure.hex(3)
      return short_code unless find_by_short_code(short_code)
    end
  end
end
