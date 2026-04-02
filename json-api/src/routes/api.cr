require "json"

require "../helpers/json_response"
require "../models/note"

private def read_json_object(env : HTTP::Server::Context) : Hash(String, JSON::Any)?
  raw = env.request.body.try(&.gets_to_end) || ""
  return nil if raw.strip.empty?

  parsed = JSON.parse(raw)
  parsed.as_h?
rescue JSON::ParseException
  nil
end

private def note_id(env : HTTP::Server::Context) : Int64?
  env.params.url["id"].to_i64?
end

private def string_field(h : Hash(String, JSON::Any), key : String) : String?
  h[key]?.try(&.as_s?)
end

get "/api/notes" do |env|
  list = Note.all.map(&.to_h)
  JsonApi::JsonResponse.json(env, 200, {"notes" => list}.to_json)
end

get "/api/notes/:id" do |env|
  id = note_id(env)
  unless id
    next JsonApi::JsonResponse.error(env, 400, "invalid id")
  end

  note = Note.find(id)
  if note
    JsonApi::JsonResponse.json(env, 200, note.to_h.to_json)
  else
    JsonApi::JsonResponse.error(env, 404, "note not found")
  end
end

post "/api/notes" do |env|
  obj = read_json_object(env)
  unless obj
    next JsonApi::JsonResponse.error(env, 400, "expected JSON object body")
  end

  title = string_field(obj, "title").try(&.strip) || ""
  if title.empty?
    next JsonApi::JsonResponse.error(env, 422, "title is required")
  end

  body = string_field(obj, "body").try(&.strip) || ""

  new_id = Note.create(title, body)
  note = Note.find(new_id)
  unless note
    next JsonApi::JsonResponse.error(env, 500, "failed to load created note")
  end

  JsonApi::JsonResponse.json(env, 201, note.to_h.to_json)
end

put "/api/notes/:id" do |env|
  id = note_id(env)
  unless id
    next JsonApi::JsonResponse.error(env, 400, "invalid id")
  end

  note = Note.find(id)
  unless note
    next JsonApi::JsonResponse.error(env, 404, "note not found")
  end

  obj = read_json_object(env)
  unless obj
    next JsonApi::JsonResponse.error(env, 400, "expected JSON object body")
  end

  title = string_field(obj, "title").try(&.strip) || ""
  if title.empty?
    next JsonApi::JsonResponse.error(env, 422, "title is required")
  end

  body = string_field(obj, "body").try(&.strip) || ""

  note.update(title, body)
  updated = Note.find(id)
  unless updated
    next JsonApi::JsonResponse.error(env, 500, "failed to load updated note")
  end

  JsonApi::JsonResponse.json(env, 200, updated.to_h.to_json)
end

patch "/api/notes/:id" do |env|
  id = note_id(env)
  unless id
    next JsonApi::JsonResponse.error(env, 400, "invalid id")
  end

  note = Note.find(id)
  unless note
    next JsonApi::JsonResponse.error(env, 404, "note not found")
  end

  obj = read_json_object(env)
  unless obj
    next JsonApi::JsonResponse.error(env, 400, "expected JSON object body")
  end

  title = obj.has_key?("title") ? (string_field(obj, "title").try(&.strip) || "") : note.title
  body = obj.has_key?("body") ? (string_field(obj, "body").try(&.strip) || "") : note.body

  if title.empty?
    next JsonApi::JsonResponse.error(env, 422, "title cannot be empty")
  end

  note.update(title, body)
  updated = Note.find(id)
  unless updated
    next JsonApi::JsonResponse.error(env, 500, "failed to load updated note")
  end

  JsonApi::JsonResponse.json(env, 200, updated.to_h.to_json)
end

delete "/api/notes/:id" do |env|
  id = note_id(env)
  unless id
    next JsonApi::JsonResponse.error(env, 400, "invalid id")
  end

  note = Note.find(id)
  unless note
    next JsonApi::JsonResponse.error(env, 404, "note not found")
  end

  note.delete
  env.response.status_code = 204
  ""
end