class CartItem
  include DB::Serializable

  getter id : Int64?
  getter user_id : Int64
  getter product_id : Int64
  getter quantity : Int64
  getter created_at : String
  getter updated_at : String

  def initialize(
    @user_id : Int64,
    @product_id : Int64,
    @quantity : Int64 = 1_i64,
    @id : Int64? = nil,
    @created_at : String = Time.utc.to_s,
    @updated_at : String = Time.utc.to_s
  )
  end

  class CartLine
    include DB::Serializable

    getter id : Int64?
    getter user_id : Int64
    getter product_id : Int64
    getter quantity : Int64
    getter name : String
    getter description : String
    getter price_cents : Int64
    getter inventory_count : Int64

    def initialize(
      @user_id : Int64,
      @product_id : Int64,
      @quantity : Int64,
      @name : String,
      @description : String,
      @price_cents : Int64,
      @inventory_count : Int64,
      @id : Int64? = nil
    )
    end

    def line_total_cents : Int64
      price_cents * quantity
    end

    def formatted_price : String
      dollars = price_cents // 100
      cents = price_cents % 100
      "$#{dollars}.#{cents.to_s.rjust(2, '0')}"
    end

    def formatted_line_total : String
      dollars = line_total_cents // 100
      cents = line_total_cents % 100
      "$#{dollars}.#{cents.to_s.rjust(2, '0')}"
    end
  end

  def self.find(id : Int64) : CartItem?
    Ecommerce::Database.connection.query_one?(
      "SELECT id, user_id, product_id, quantity, created_at, updated_at FROM cart_items WHERE id = ?",
      id,
      as: CartItem
    )
  end

  def self.find_by_user_and_product(user_id : Int64, product_id : Int64) : CartItem?
    Ecommerce::Database.connection.query_one?(
      "SELECT id, user_id, product_id, quantity, created_at, updated_at FROM cart_items WHERE user_id = ? AND product_id = ?",
      user_id,
      product_id,
      as: CartItem
    )
  end

  def self.add_product(user_id : Int64, product_id : Int64)
    item = find_by_user_and_product(user_id, product_id)

    if item
      item.update_quantity(item.quantity + 1)
      return
    end

    now = Time.utc.to_s
    Ecommerce::Database.connection.exec(
      "INSERT INTO cart_items (user_id, product_id, quantity, created_at, updated_at) VALUES (?, ?, ?, ?, ?)",
      user_id,
      product_id,
      1_i64,
      now,
      now
    )
  end

  def update_quantity(quantity : Int64)
    return unless id

    if quantity <= 0
      delete
      return
    end

    Ecommerce::Database.connection.exec(
      "UPDATE cart_items SET quantity = ?, updated_at = ? WHERE id = ?",
      quantity,
      Time.utc.to_s,
      id
    )
  end

  def delete
    return unless id

    Ecommerce::Database.connection.exec(
      "DELETE FROM cart_items WHERE id = ?",
      id
    )
  end

  def self.cart_lines_for_user(user_id : Int64) : Array(CartLine)
    Ecommerce::Database.connection.query_all(
      "SELECT cart_items.id, cart_items.user_id, cart_items.product_id, cart_items.quantity, products.name, products.description, products.price_cents, products.inventory_count FROM cart_items INNER JOIN products ON products.id = cart_items.product_id WHERE cart_items.user_id = ? ORDER BY cart_items.id DESC",
      user_id,
      as: CartLine
    )
  end

  def self.total_quantity_for_user(user_id : Int64) : Int64
    Ecommerce::Database.connection.query_one(
      "SELECT COALESCE(SUM(quantity), 0) FROM cart_items WHERE user_id = ?",
      user_id,
      as: Int64
    )
  end

  def self.total_price_cents_for_user(user_id : Int64) : Int64
    Ecommerce::Database.connection.query_one(
      "SELECT COALESCE(SUM(cart_items.quantity * products.price_cents), 0) FROM cart_items INNER JOIN products ON products.id = cart_items.product_id WHERE cart_items.user_id = ?",
      user_id,
      as: Int64
    )
  end

  def self.clear_for_user(user_id : Int64)
    Ecommerce::Database.connection.exec(
      "DELETE FROM cart_items WHERE user_id = ?",
      user_id
    )
  end

  def self.formatted_total_price(total_price_cents : Int64) : String
    dollars = total_price_cents // 100
    cents = total_price_cents % 100
    "$#{dollars}.#{cents.to_s.rjust(2, '0')}"
  end
end
