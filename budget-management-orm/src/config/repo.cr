require "sqlite3"
require "crecto"

module BudgetManagementOrm
  module Repo
    extend Crecto::Repo

    config do |conf|
      conf.adapter = Crecto::Adapters::SQLite3
      conf.database = ENV["BUDGET_DATABASE"]? || "./db/budget_management.db"
    end
  end
end
