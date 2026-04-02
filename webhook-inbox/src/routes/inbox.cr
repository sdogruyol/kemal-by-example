require "json"

require "../config/app"
require "../helpers/headers_json"
require "../models/webhook_event"

post "/hooks/inbox" do |env|
  raw = env.request.body.try(&.gets_to_end) || ""
  content_type = env.request.headers["Content-Type"]? || ""

  signature_status =
    if WebhookInbox.hmac_enabled?
      "kemal-hmac:#{env.kemal_authorized_client?.not_nil!}"
    else
      "none"
    end

  headers_json = WebhookInbox::HeadersJson.from_request(env)
  id = WebhookEvent.create(content_type, raw, headers_json, signature_status)

  env.response.content_type = "application/json; charset=utf-8"
  env.response.status_code = 200
  {"received" => true, "id" => id}.to_json
end
