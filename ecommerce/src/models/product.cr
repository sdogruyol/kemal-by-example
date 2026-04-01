class Product
  include DB::Serializable

  getter id : Int64?
  getter name : String
  getter description : String
  getter price_cents : Int64
  getter inventory_count : Int64
  getter created_at : String
  getter updated_at : String

  def initialize(
    @name : String,
    @description : String,
    @price_cents : Int64,
    @inventory_count : Int64 = 0_i64,
    @id : Int64? = nil,
    @created_at : String = Time.utc.to_s,
    @updated_at : String = Time.utc.to_s
  )
  end

  def self.all : Array(Product)
    Ecommerce::Database.connection.query_all(
      "SELECT id, name, description, price_cents, inventory_count, created_at, updated_at FROM products ORDER BY id ASC",
      as: Product
    )
  end

  def self.find(id : Int64) : Product?
    Ecommerce::Database.connection.query_one?(
      "SELECT id, name, description, price_cents, inventory_count, created_at, updated_at FROM products WHERE id = ?",
      id,
      as: Product
    )
  end

  def available? : Bool
    inventory_count > 0
  end

  def formatted_price : String
    dollars = price_cents // 100
    cents = price_cents % 100
    "$#{dollars}.#{cents.to_s.rjust(2, '0')}"
  end

  def self.seed_defaults
    count = Ecommerce::Database.connection.scalar("SELECT COUNT(*) FROM products").as(Int64)
    return unless count.zero?

    now = Time.utc.to_s

    products = [
      {"Kemal Hoodie", "Soft fleece hoodie for late-night coding sessions.", 5900_i64, 18_i64},
      {"Crystal Mug", "A clean desk companion for coffee, tea, or pure ambition.", 1800_i64, 32_i64},
      {"Mechanical Keyboard", "Tactile keyboard tuned for fast builds and faster shipping.", 12900_i64, 9_i64},
      {"Developer Backpack", "A compact backpack for laptops, chargers, and daily essentials.", 8900_i64, 12_i64},
    ]

    products.each do |product|
      Ecommerce::Database.connection.exec(
        "INSERT INTO products (name, description, price_cents, inventory_count, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)",
        product[0],
        product[1],
        product[2],
        product[3],
        now,
        now
      )
    end
  end
end
