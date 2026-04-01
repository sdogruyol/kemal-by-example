get "/products" do |env|
  current_user = Ecommerce::Auth.current_user(env)
  cart_count = current_user ? CartItem.total_quantity_for_user(current_user.id.not_nil!) : 0_i64
  products = Product.all

  render "src/views/products/index.ecr", "src/views/layouts/application.ecr"
end
