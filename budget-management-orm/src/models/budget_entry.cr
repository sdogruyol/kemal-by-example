require "../config/repo"

module BudgetManagementOrm
  class BudgetEntry < Crecto::Model
    schema "budget_entries" do
      field :title, String
      field :kind, String
      field :amount_cents, Int64
      field :notes, String
    end

    validate_required :title
    validate_inclusion :kind, ["income", "expense"]

    def income? : Bool
      kind == "income"
    end

    def expense? : Bool
      kind == "expense"
    end

    def self.all_ordered : Array(BudgetEntry)
      query = Crecto::Repo::Query.new.order_by("id DESC")
      Repo.all(BudgetEntry, query)
    end

    def self.find(id : Int64) : BudgetEntry?
      Repo.get(BudgetEntry, id)
    end

    def self.income_total_cents(entries : Array(BudgetEntry)) : Int64
      entries.sum(0_i64) { |e| e.income? ? (e.amount_cents || 0_i64) : 0_i64 }
    end

    def self.expense_total_cents(entries : Array(BudgetEntry)) : Int64
      entries.sum(0_i64) { |e| e.expense? ? (e.amount_cents || 0_i64) : 0_i64 }
    end

    def self.balance_cents(entries : Array(BudgetEntry)) : Int64
      income_total_cents(entries) - expense_total_cents(entries)
    end

    def self.create(title : String, kind : String, notes : String, amount_cents : Int64)
      entry = BudgetEntry.new
      entry.title = title
      entry.kind = kind
      entry.notes = notes
      entry.amount_cents = amount_cents
      Repo.insert(entry)
    end

    def update_fields(title : String, kind : String, notes : String, amount_cents : Int64)
      self.title = title
      self.kind = kind
      self.notes = notes
      self.amount_cents = amount_cents
      Repo.update(self)
    end

    def destroy
      Repo.delete(self)
    end
  end
end
