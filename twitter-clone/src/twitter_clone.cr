require "kemal"
require "db"
require "sqlite3"
require "json"

require "./config/database"
require "./config/schema"
require "./helpers/realtime"
require "./models/tweet"
require "./routes/home"
require "./routes/tweets"

TwitterClone::Schema.setup
Kemal.run
