module Ecommerce
  module Auth
    extend self

    def current_user(env) : User?
      cookie = env.request.cookies["user_id"]?
      return unless cookie

      user_id = cookie.value
      return if user_id.empty?

      User.find(user_id.to_i64)
    rescue
      nil
    end

    def require_user(env) : User?
      user = current_user(env)
      return user if user

      env.redirect "/login"
      nil
    end

    def sign_in(env, user : User)
      env.response.cookies["user_id"] = user.id.to_s
    end

    def sign_out(env)
      env.response.cookies["user_id"] = ""
    end
  end
end
