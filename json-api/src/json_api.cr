require "kemal"
require "db"
require "sqlite3"

require "./config/database"
require "./config/schema"
require "./models/note"
require "./routes/home"
require "./routes/api"

JsonApi::Schema.setup
Kemal.run
