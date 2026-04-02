require "kemal-hmac"

# Protects only `POST /hooks/inbox` with [kemal-hmac](https://github.com/kemalcr/kemal-hmac).
# Other routes skip this handler.
class WebhookInbox::InboxHmacHandler < Kemal::Hmac::Handler
  only ["/hooks/inbox"], "POST"

  def call(context)
    return call_next(context) unless only_match?(context)
    super
  end
end
