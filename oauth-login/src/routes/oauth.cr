require "random"

require "../helpers/auth"
require "../models/user"
require "../services/github_oauth"

get "/auth/github" do |env|
  unless OauthLogin::GithubOauth.configured?
    env.flash["error"] = "Set GITHUB_CLIENT_ID and GITHUB_CLIENT_SECRET. See README."
    env.redirect "/"
    next
  end

  state = Random::Secure.random_bytes(16).hexstring
  env.session.string("oauth_state", state)
  env.redirect OauthLogin::GithubOauth.authorize_url(state)
end

get "/auth/github/callback" do |env|
  code = env.params.query["code"]?
  state = env.params.query["state"]?
  stored = env.session.string?("oauth_state")
  env.session.delete_string("oauth_state")

  unless code && state && stored && state == stored
    env.flash["error"] = "OAuth state mismatch or missing code."
    env.redirect "/"
    next
  end

  token = OauthLogin::GithubOauth.exchange_code(code)
  unless token
    env.flash["error"] = "Could not exchange code for token."
    env.redirect "/"
    next
  end

  gh_json = OauthLogin::GithubOauth.fetch_github_user(token)
  unless gh_json
    env.flash["error"] = "Could not load GitHub profile."
    env.redirect "/"
    next
  end

  parsed = OauthLogin::GithubOauth.user_from_github_json(gh_json)
  unless parsed
    env.flash["error"] = "Unexpected GitHub user payload."
    env.redirect "/"
    next
  end

  github_id, login, name, avatar_url, email = parsed

  if email.nil?
    email = OauthLogin::GithubOauth.fetch_primary_email(token)
  end

  user = User.upsert_from_github(github_id, login, name, avatar_url, email)
  OauthLogin::Auth.sign_in(env, user)
  env.redirect "/"
end

post "/logout" do |env|
  OauthLogin::Auth.sign_out(env)
  env.redirect "/"
end
