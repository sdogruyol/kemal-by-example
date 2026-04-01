get "/posts" do
  posts = Post.all
  render "src/views/posts/index.ecr", "src/views/layouts/application.ecr"
end

get "/posts/:id/edit" do |env|
  post = Post.find(env.params.url["id"].to_i64)

  if post
    render "src/views/posts/edit.ecr", "src/views/layouts/application.ecr"
  else
    env.response.status_code = 404
    "Post not found"
  end
end

post "/posts" do |env|
  title = env.params.body["title"]?.try(&.strip) || ""
  body = env.params.body["body"]?.try(&.strip) || ""

  Post.create(title, body)
  env.redirect "/posts"
end

post "/posts/:id" do |env|
  post = Post.find(env.params.url["id"].to_i64)

  if post
    title = env.params.body["title"]?.try(&.strip) || ""
    body = env.params.body["body"]?.try(&.strip) || ""

    post.update(title, body)
    env.redirect "/posts"
  else
    env.response.status_code = 404
    "Post not found"
  end
end

post "/posts/:id/delete" do |env|
  post = Post.find(env.params.url["id"].to_i64)

  post.try(&.delete)
  env.redirect "/posts"
end
