require "kemal"
require "db"
require "sqlite3"

require "./config/database"
require "./config/schema"
require "./models/post"
require "./routes/home"
require "./routes/posts"

Blog::Schema.setup
Kemal.run
