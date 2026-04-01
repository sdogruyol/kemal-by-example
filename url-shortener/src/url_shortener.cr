require "kemal"
require "db"
require "sqlite3"

require "./config/database"
require "./config/schema"
require "./models/short_url"
require "./routes/home"
require "./routes/short_urls"

UrlShortener::Schema.setup
Kemal.run
