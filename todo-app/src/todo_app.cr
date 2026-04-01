require "kemal"
require "db"
require "sqlite3"

require "./config/database"
require "./config/schema"
require "./models/todo"
require "./routes/home"
require "./routes/todos"

TodoApp::Schema.setup
Kemal.run
