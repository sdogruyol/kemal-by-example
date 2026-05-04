get "/entries" do
  entries = BudgetManagementOrm::BudgetEntry.all_ordered
  total_income_cents = BudgetManagementOrm::BudgetEntry.income_total_cents(entries)
  total_expense_cents = BudgetManagementOrm::BudgetEntry.expense_total_cents(entries)
  balance_cents = BudgetManagementOrm::BudgetEntry.balance_cents(entries)
  render "src/views/entries/index.ecr", "src/views/layouts/application.ecr"
end

get "/entries/:id/edit" do |env|
  entry = BudgetManagementOrm::BudgetEntry.find(env.params.url["id"].to_i64)

  if entry
    amount_display = BudgetManagementOrm::Money.format_cents(entry.amount_cents)
    render "src/views/entries/edit.ecr", "src/views/layouts/application.ecr"
  else
    env.response.status_code = 404
    "Entry not found"
  end
end

post "/entries" do |env|
  title = env.params.body["title"]?.try(&.strip) || ""
  raw_kind = env.params.body["kind"]? || "expense"
  kind = raw_kind == "income" ? "income" : "expense"
  notes = env.params.body["notes"]?.try(&.strip) || ""
  cents = BudgetManagementOrm::Money.parse_cents(env.params.body["amount"]? || "")

  if !title.empty? && cents && cents > 0
    BudgetManagementOrm::BudgetEntry.create(title, kind, notes, cents)
  end

  env.redirect "/entries"
end

post "/entries/:id" do |env|
  entry = BudgetManagementOrm::BudgetEntry.find(env.params.url["id"].to_i64)

  unless entry
    env.response.status_code = 404
    next "Entry not found"
  end

  title = env.params.body["title"]?.try(&.strip) || ""
  raw_kind = env.params.body["kind"]? || "expense"
  kind = raw_kind == "income" ? "income" : "expense"
  notes = env.params.body["notes"]?.try(&.strip) || ""
  cents = BudgetManagementOrm::Money.parse_cents(env.params.body["amount"]? || "")

  if !title.empty? && cents && cents > 0
    entry.update_fields(title, kind, notes, cents)
  end

  env.redirect "/entries"
end

post "/entries/:id/delete" do |env|
  entry = BudgetManagementOrm::BudgetEntry.find(env.params.url["id"].to_i64)
  entry.try(&.destroy)
  env.redirect "/entries"
end
