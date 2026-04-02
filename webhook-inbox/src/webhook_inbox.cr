require "html"
require "kemal"
require "kemal-hmac"
require "db"
require "sqlite3"

require "./config/app"
require "./config/database"
require "./config/schema"
require "./models/webhook_event"
require "./middleware/inbox_hmac_handler"
require "./routes/home"
require "./routes/inbox"
require "./routes/events"

WebhookInbox::Schema.setup

if WebhookInbox.hmac_enabled?
  Kemal.config.hmac_handler = WebhookInbox::InboxHmacHandler
  client = WebhookInbox.hmac_client_name
  add_handler WebhookInbox::InboxHmacHandler.new({client => [WebhookInbox.webhook_secret]})
end

Kemal.run
