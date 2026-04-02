require "json"

class WebhookEvent
  include DB::Serializable

  getter id : Int64?
  getter created_at : String
  getter content_type : String
  getter body : String
  getter headers_json : String
  getter signature_status : String

  def initialize(
    @content_type : String,
    @body : String,
    @headers_json : String,
    @signature_status : String,
    @id : Int64? = nil,
    @created_at : String = Time.utc.to_s,
  )
  end

  def self.recent(limit : Int32 = 50) : Array(WebhookEvent)
    WebhookInbox::Database.connection.query_all(
      "SELECT id, created_at, content_type, body, headers_json, signature_status FROM webhook_events ORDER BY id DESC LIMIT ?",
      limit,
      as: WebhookEvent
    )
  end

  def self.find(id : Int64) : WebhookEvent?
    WebhookInbox::Database.connection.query_one?(
      "SELECT id, created_at, content_type, body, headers_json, signature_status FROM webhook_events WHERE id = ?",
      id,
      as: WebhookEvent
    )
  end

  def self.create(content_type : String, body : String, headers_json : String, signature_status : String) : Int64
    now = Time.utc.to_s
    db = WebhookInbox::Database.connection
    db.exec(
      "INSERT INTO webhook_events (created_at, content_type, body, headers_json, signature_status) VALUES (?, ?, ?, ?, ?)",
      now,
      content_type,
      body,
      headers_json,
      signature_status
    )
    db.scalar("SELECT last_insert_rowid()").as(Int64)
  end

  def headers_pretty : String
    any = JSON.parse(headers_json)
    if any.as_h?
      any.as_h.to_pretty_json
    else
      any.to_json
    end
  rescue
    headers_json
  end

  def preview(max : Int32 = 160) : String
    return body if body.size <= max

    "#{body[0, max]}…"
  end
end
