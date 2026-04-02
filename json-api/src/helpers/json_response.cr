module JsonApi
  module JsonResponse
    extend self

    def json(env : HTTP::Server::Context, status : Int32, payload : String)
      env.response.status_code = status
      env.response.content_type = "application/json; charset=utf-8"
      payload
    end

    def error(env : HTTP::Server::Context, status : Int32, message : String)
      json(env, status, {"error" => message}.to_json)
    end
  end
end
