require "kemal"
require "db"
require "sqlite3"
require "json"

require "./config/database"
require "./config/schema"
require "./models/metric_snapshot"
require "./services/system_metrics"
require "./services/metrics_hub"
require "./routes/home"
require "./routes/dashboard"

RealTimeDashboard::Schema.setup
RealTimeDashboard::MetricsHub.start
Kemal.run
