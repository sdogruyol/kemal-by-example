require "../helpers/auth"

get "/" do |env|
  current_user = OauthLogin::Auth.current_user(env)
  oauth_ready = OauthLogin::GithubOauth.configured?
  error_message = env.flash["error"]?

  render "src/views/home/index.ecr", "src/views/layouts/application.ecr"
end
