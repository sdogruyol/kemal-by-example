require "kemal"
require "sqlite3"
require "crecto"

require "./config/repo"
require "./config/schema"
require "./lib/money"
require "./models/budget_entry"
require "./routes/home"
require "./routes/entries"

BudgetManagementOrm::Schema.setup
Kemal.run
