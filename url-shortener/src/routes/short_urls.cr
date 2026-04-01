get "/links" do |env|
  short_urls = ShortUrl.all
  host = env.request.headers["Host"]? || "127.0.0.1:3000"
  base_url = "http://#{host}"

  render "src/views/short_urls/index.ecr", "src/views/layouts/application.ecr"
end

get "/links/:id/edit" do |env|
  short_url = ShortUrl.find(env.params.url["id"].to_i64)

  if short_url
    render "src/views/short_urls/edit.ecr", "src/views/layouts/application.ecr"
  else
    env.response.status_code = 404
    "Short URL not found"
  end
end

post "/links" do |env|
  title = env.params.body["title"]?.try(&.strip) || ""
  original_url = env.params.body["original_url"]?.try(&.strip) || ""

  ShortUrl.create(original_url, title)
  env.redirect "/links"
end

post "/links/:id" do |env|
  short_url = ShortUrl.find(env.params.url["id"].to_i64)

  if short_url
    title = env.params.body["title"]?.try(&.strip) || ""
    original_url = env.params.body["original_url"]?.try(&.strip) || ""

    short_url.update(title, original_url)
    env.redirect "/links"
  else
    env.response.status_code = 404
    "Short URL not found"
  end
end

post "/links/:id/delete" do |env|
  short_url = ShortUrl.find(env.params.url["id"].to_i64)

  short_url.try(&.delete)
  env.redirect "/links"
end

get "/:short_code" do |env|
  short_url = ShortUrl.find_by_short_code(env.params.url["short_code"])

  if short_url
    short_url.register_click
    env.redirect short_url.original_url
  else
    env.response.status_code = 404
    "Short URL not found"
  end
end
