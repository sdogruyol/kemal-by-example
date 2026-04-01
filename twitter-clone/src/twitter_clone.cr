require "kemal"
require "db"
require "sqlite3"

require "./config/database"
require "./config/schema"
require "./models/tweet"
require "./routes/home"
require "./routes/tweets"

TwitterClone::Schema.setup
Kemal.run
