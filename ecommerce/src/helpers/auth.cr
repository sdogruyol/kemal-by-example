module Ecommerce
  module Auth
    extend self

    def current_user(env) : User?
      user_id = env.session.bigint?("user_id")
      return unless user_id

      User.find(user_id)
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
      env.session.bigint("user_id", user.id.not_nil!)
    end

    def sign_out(env)
      env.session.destroy
    end
  end
end
