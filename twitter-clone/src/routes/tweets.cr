get "/timeline" do
  tweets = Tweet.all
  render "src/views/tweets/index.ecr", "src/views/layouts/application.ecr"
end

ws "/timeline/socket" do |socket|
  TwitterClone::Realtime.register(socket)

  socket.on_close do
    TwitterClone::Realtime.unregister(socket)
  end
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

  tweet = Tweet.create(display_name, username, body)
  TwitterClone::Realtime.broadcast_tweet_created(tweet)
  env.redirect "/timeline"
end

post "/tweets/:id" do |env|
  tweet = Tweet.find(env.params.url["id"].to_i64)

  if tweet
    display_name = env.params.body["display_name"]?.try(&.strip) || ""
    username = env.params.body["username"]?.try(&.strip) || ""
    body = env.params.body["body"]?.try(&.strip) || ""

    updated_tweet = tweet.update(display_name, username, body)
    TwitterClone::Realtime.broadcast_tweet_updated(updated_tweet.not_nil!) if updated_tweet
    env.redirect "/timeline"
  else
    env.response.status_code = 404
    "Tweet not found"
  end
end

post "/tweets/:id/like" do |env|
  tweet = Tweet.find(env.params.url["id"].to_i64)

  if tweet
    liked_tweet = tweet.like
    TwitterClone::Realtime.broadcast_tweet_liked(liked_tweet.not_nil!) if liked_tweet
    env.redirect "/timeline"
  else
    env.response.status_code = 404
    "Tweet not found"
  end
end

post "/tweets/:id/delete" do |env|
  tweet = Tweet.find(env.params.url["id"].to_i64)

  deleted_id = tweet.try(&.delete)
  TwitterClone::Realtime.broadcast_tweet_deleted(deleted_id.not_nil!) if deleted_id
  env.redirect "/timeline"
end
