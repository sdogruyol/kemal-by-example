module WebhookInbox
  def self.hmac_client_name : String
    v = ENV["HMAC_CLIENT_NAME"]?.try(&.strip)
    if v && !v.empty?
      v
    else
      "webhook"
    end
  end

  def self.hmac_enabled? : Bool
    s = ENV["WEBHOOK_SECRET"]?
    !!(s && !s.strip.empty?)
  end

  def self.webhook_secret : String
    ENV["WEBHOOK_SECRET"].not_nil!.strip
  end
end
