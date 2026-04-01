get "/cart" do |env|
  user = Ecommerce::Auth.require_user(env)
  next "" unless user

  current_user = user
  cart_count = CartItem.total_quantity_for_user(user.id.not_nil!)
  cart_lines = CartItem.cart_lines_for_user(user.id.not_nil!)
  total_price_cents = CartItem.total_price_cents_for_user(user.id.not_nil!)
  total_price = CartItem.formatted_total_price(total_price_cents)
  checkout_notice = env.params.query["checked_out"]? == "1"

  render "src/views/cart/show.ecr", "src/views/layouts/application.ecr"
end

post "/cart/items" do |env|
  user = Ecommerce::Auth.require_user(env)
  next "" unless user

  product_id = env.params.body["product_id"].to_i64
  product = Product.find(product_id)

  if product && product.available?
    CartItem.add_product(user.id.not_nil!, product_id)
  end

  env.redirect "/cart"
end

post "/cart/items/:id" do |env|
  user = Ecommerce::Auth.require_user(env)
  next "" unless user

  cart_item = CartItem.find(env.params.url["id"].to_i64)

  if cart_item && cart_item.user_id == user.id
    quantity = env.params.body["quantity"]?.try(&.to_i64) || 1_i64
    cart_item.update_quantity(quantity)
    env.redirect "/cart"
  else
    env.response.status_code = 404
    "Cart item not found"
  end
end

post "/cart/items/:id/delete" do |env|
  user = Ecommerce::Auth.require_user(env)
  next "" unless user

  cart_item = CartItem.find(env.params.url["id"].to_i64)

  if cart_item && cart_item.user_id == user.id
    cart_item.delete
    env.redirect "/cart"
  else
    env.response.status_code = 404
    "Cart item not found"
  end
end

post "/cart/checkout" do |env|
  user = Ecommerce::Auth.require_user(env)
  next "" unless user

  CartItem.clear_for_user(user.id.not_nil!)
  env.redirect "/cart?checked_out=1"
end
