get "/signup" do |env|
  current_user = Ecommerce::Auth.current_user(env)
  cart_count = current_user ? CartItem.total_quantity_for_user(current_user.id.not_nil!) : 0_i64
  error_message = nil

  render "src/views/auth/signup.ecr", "src/views/layouts/application.ecr"
end

post "/signup" do |env|
  name = env.params.body["name"]?.try(&.strip) || ""
  email = env.params.body["email"]?.try(&.strip) || ""
  password = env.params.body["password"]?.try(&.strip) || ""

  if name.empty? || email.empty? || password.empty?
    current_user = nil
    cart_count = 0_i64
    error_message = "Name, email, and password are required."
    env.response.status_code = 422
    render "src/views/auth/signup.ecr", "src/views/layouts/application.ecr"
  elsif User.find_by_email(email)
    current_user = nil
    cart_count = 0_i64
    error_message = "An account with this email already exists."
    env.response.status_code = 422
    render "src/views/auth/signup.ecr", "src/views/layouts/application.ecr"
  else
    user = User.create(name, email, password)
    Ecommerce::Auth.sign_in(env, user)
    env.redirect "/products"
  end
end

get "/login" do |env|
  current_user = Ecommerce::Auth.current_user(env)
  cart_count = current_user ? CartItem.total_quantity_for_user(current_user.id.not_nil!) : 0_i64
  error_message = nil

  render "src/views/auth/login.ecr", "src/views/layouts/application.ecr"
end

post "/login" do |env|
  email = env.params.body["email"]?.try(&.strip) || ""
  password = env.params.body["password"]?.try(&.strip) || ""
  user = User.authenticate(email, password)

  if user
    Ecommerce::Auth.sign_in(env, user)
    env.redirect "/products"
  else
    current_user = nil
    cart_count = 0_i64
    error_message = "Invalid email or password."
    env.response.status_code = 422
    render "src/views/auth/login.ecr", "src/views/layouts/application.ecr"
  end
end

post "/logout" do |env|
  Ecommerce::Auth.sign_out(env)
  env.redirect "/products"
end
