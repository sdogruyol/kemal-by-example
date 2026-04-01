require "kemal"
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

Ecommerce::Schema.setup
Product.seed_defaults
Kemal.run
