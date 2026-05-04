module BudgetManagementOrm
  module Money
    extend self

    def format_cents(cents : Int64?) : String
      format_cents(cents || 0_i64)
    end

    def format_cents(cents : Int64) : String
      neg = cents < 0
      abs = cents.abs
      whole = abs // 100
      frac = abs % 100
      prefix = neg ? "-" : ""
      "#{prefix}#{whole}.#{frac.to_s.rjust(2, '0')}"
    end

    def parse_cents(raw : String) : Int64?
      t = raw.strip
      return nil if t.empty?

      (t.to_f64 * 100.0).round.to_i64
    rescue ArgumentError
      nil
    end
  end
end
