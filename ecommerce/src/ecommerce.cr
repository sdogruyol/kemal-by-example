require "kemal"
require "kemal-session"
require "db"
require "sqlite3"

require "./config/database"
require "./config/schema"
require "./helpers/auth"
require "./models/user"
require "./models/product"
require "./models/cart_item"
require "./routes/home"
require "./routes/auth"
require "./routes/products"
require "./routes/cart"

Kemal::Session.config do |config|
  config.secret = ENV["KEMAL_SESSION_SECRET"]? || "ecommerce-dev-session-secret"
  config.cookie_name = "ecommerce_session_id"
  config.gc_interval = 2.minutes
end

Ecommerce::Schema.setup
Product.seed_defaults
Kemal.run
