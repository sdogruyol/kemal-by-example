get "/timeline" do
  tweets = Tweet.all
  render "src/views/tweets/index.ecr", "src/views/layouts/application.ecr"
end

get "/tweets/:id/edit" do |env|
  tweet = Tweet.find(env.params.url["id"].to_i64)

  if tweet
    render "src/views/tweets/edit.ecr", "src/views/layouts/application.ecr"
  else
    env.response.status_code = 404
    "Tweet not found"
  end
end

post "/tweets" do |env|
  display_name = env.params.body["display_name"]?.try(&.strip) || ""
  username = env.params.body["username"]?.try(&.strip) || ""
  body = env.params.body["body"]?.try(&.strip) || ""

  Tweet.create(display_name, username, body)
  env.redirect "/timeline"
end

post "/tweets/:id" do |env|
  tweet = Tweet.find(env.params.url["id"].to_i64)

  if tweet
    display_name = env.params.body["display_name"]?.try(&.strip) || ""
    username = env.params.body["username"]?.try(&.strip) || ""
    body = env.params.body["body"]?.try(&.strip) || ""

    tweet.update(display_name, username, body)
    env.redirect "/timeline"
  else
    env.response.status_code = 404
    "Tweet not found"
  end
end

post "/tweets/:id/like" do |env|
  tweet = Tweet.find(env.params.url["id"].to_i64)

  if tweet
    tweet.like
    env.redirect "/timeline"
  else
    env.response.status_code = 404
    "Tweet not found"
  end
end

post "/tweets/:id/delete" do |env|
  tweet = Tweet.find(env.params.url["id"].to_i64)

  tweet.try(&.delete)
  env.redirect "/timeline"
end
