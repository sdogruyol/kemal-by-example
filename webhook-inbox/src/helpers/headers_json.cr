require "json"

module WebhookInbox
  module HeadersJson
    extend self

    def from_request(env : HTTP::Server::Context) : String
      h = {} of String => String
      env.request.headers.each do |k, v|
        h[k] = v.first
      end
      h.to_json
    end
  end
end
