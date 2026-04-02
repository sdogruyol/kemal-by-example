require "kemal"
require "kemal-session"
require "db"
require "sqlite3"

require "./config/database"
require "./config/schema"
require "./helpers/auth"
require "./models/user"
require "./services/github_oauth"
require "./routes/home"
require "./routes/oauth"

Kemal::Session.config do |config|
  config.secret = ENV["KEMAL_SESSION_SECRET"]? || "oauth-login-dev-secret"
  config.cookie_name = "oauth_login_session"
  config.gc_interval = 2.minutes
end

OauthLogin::Schema.setup
Kemal.run
