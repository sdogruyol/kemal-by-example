require "json"

require "../helpers/json_response"

get "/" do |env|
  payload = {
    "name"        => "json-api",
    "description" => "REST JSON API for notes (Kemal + SQLite)",
    "endpoints"   => [
      {"method" => "GET", "path" => "/api/notes", "description" => "List all notes"},
      {"method" => "GET", "path" => "/api/notes/:id", "description" => "Get one note"},
      {"method" => "POST", "path" => "/api/notes", "description" => "Create note (JSON: title, body?)"},
      {"method" => "PUT", "path" => "/api/notes/:id", "description" => "Replace note (JSON: title, body?)"},
      {"method" => "PATCH", "path" => "/api/notes/:id", "description" => "Partial update (JSON: title?, body?)"},
      {"method" => "DELETE", "path" => "/api/notes/:id", "description" => "Delete note"},
    ],
  }
  JsonApi::JsonResponse.json(env, 200, payload.to_json)
end
