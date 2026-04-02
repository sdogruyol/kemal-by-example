require "http/client"
require "json"
require "uri"

module OauthLogin
  module GithubOauth
    extend self

    USER_AGENT = "kemal-oauth-login"

    def client_id : String
      ENV["GITHUB_CLIENT_ID"]? || ""
    end

    def client_secret : String
      ENV["GITHUB_CLIENT_SECRET"]? || ""
    end

    def redirect_uri : String
      ENV["OAUTH_REDIRECT_URI"]? || "http://127.0.0.1:3000/auth/github/callback"
    end

    def configured? : Bool
      !client_id.empty? && !client_secret.empty?
    end

    def authorize_url(state : String) : String
      params = URI::Params.build do |form|
        form.add "client_id", client_id
        form.add "redirect_uri", redirect_uri
        form.add "scope", "read:user user:email"
        form.add "state", state
      end
      "https://github.com/login/oauth/authorize?#{params}"
    end

    def exchange_code(code : String) : String?
      body = URI::Params.encode({
        "client_id"     => client_id,
        "client_secret" => client_secret,
        "code"          => code,
        "redirect_uri"  => redirect_uri,
      })
      response = HTTP::Client.post(
        "https://github.com/login/oauth/access_token",
        headers: HTTP::Headers{
          "Accept"       => "application/json",
          "Content-Type" => "application/x-www-form-urlencoded",
          "User-Agent"   => USER_AGENT,
        },
        body: body
      )
      return nil unless response.success?

      json = JSON.parse(response.body)
      json["access_token"]?.try(&.as_s?)
    rescue JSON::ParseException
      nil
    end

    def fetch_github_user(access_token : String) : Hash(String, JSON::Any)?
      response = HTTP::Client.get(
        "https://api.github.com/user",
        headers: HTTP::Headers{
          "Authorization" => "Bearer #{access_token}",
          "Accept"        => "application/vnd.github+json",
          "User-Agent"    => USER_AGENT,
        }
      )
      return nil unless response.success?

      JSON.parse(response.body).as_h?
    rescue JSON::ParseException
      nil
    end

    def fetch_primary_email(access_token : String) : String?
      response = HTTP::Client.get(
        "https://api.github.com/user/emails",
        headers: HTTP::Headers{
          "Authorization" => "Bearer #{access_token}",
          "Accept"        => "application/vnd.github+json",
          "User-Agent"    => USER_AGENT,
        }
      )
      return nil unless response.success?

      json = JSON.parse(response.body)
      return nil unless json.as_a?

      json.as_a.each do |item|
        next unless item.as_h?
        h = item.as_h
        primary = h["primary"]?.try(&.as_bool?) || false
        verified = h["verified"]?.try(&.as_bool?) || false
        next unless primary && verified

        return h["email"]?.try(&.as_s?)
      end

      nil
    rescue JSON::ParseException
      nil
    end

    def user_from_github_json(json : Hash(String, JSON::Any)) : {Int64, String, String, String, String?}?
      gh_id = json["id"]?.try(&.as_i64?)
      return nil unless gh_id

      login = json["login"]?.try(&.as_s?)
      return nil unless login

      name = json["name"]?.try(&.as_s?).try(&.strip)
      name = login if !name || name.empty?

      avatar_url = json["avatar_url"]?.try(&.as_s?) || ""
      email = json["email"]?.try(&.as_s?).try(&.strip)
      email = nil if email && email.empty?

      {gh_id, login, name, avatar_url, email}
    end
  end
end
