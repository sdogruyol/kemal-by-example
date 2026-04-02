require "kemal"
require "db"
require "sqlite3"
require "random/secure"

require "./config/database"
require "./config/schema"
require "./models/stored_file"
require "./routes/home"
require "./routes/files"

Kemal.config.public_folder = "./public"
Kemal.config.max_request_body_size = 50 * 1024 * 1024 # 50MB

FileUploadStorage::Schema.setup
Kemal.run
