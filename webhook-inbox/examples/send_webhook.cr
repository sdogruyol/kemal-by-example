# Example: POST /hooks/inbox with kemal-hmac headers.
# Usage (from webhook-inbox/):
#   export WEBHOOK_SECRET=your_secret
#   crystal run examples/send_webhook.cr

require "http/client"
require "kemal-hmac"

secret = ENV["WEBHOOK_SECRET"]?.try(&.strip)
unless secret && !secret.empty?
  STDERR.puts "Set WEBHOOK_SECRET to match the server."
  exit 1
end

host = ENV["WEBHOOK_INBOX_URL"]? || "http://127.0.0.1:3000"
cn = ENV["HMAC_CLIENT_NAME"]?.try(&.strip)
client_name = (cn && !cn.empty?) ? cn : "webhook"
path = "/hooks/inbox"

hmac = Kemal::Hmac::Client.new(client_name, secret)
headers = HTTP::Headers.new
hmac.generate_headers(path).each { |k, v| headers.add(k, v) }

body = %({"hello":"signed","ts":"#{Time.utc.to_s}"})
uri = URI.parse("#{host}#{path}")

response = HTTP::Client.post(uri, headers: headers, body: body)
puts "HTTP #{response.status_code}"
puts response.body
