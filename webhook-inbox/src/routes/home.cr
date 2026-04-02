require "../config/app"
require "../models/webhook_event"

get "/" do |env|
  events = WebhookEvent.recent(50)
  secret_on = WebhookInbox.hmac_enabled?

  render "src/views/inbox/index.ecr", "src/views/layouts/application.ecr"
end
