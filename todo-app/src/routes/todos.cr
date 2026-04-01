get "/todos" do
  todos = Todo.all
  render "src/views/todos/index.ecr", "src/views/layouts/application.ecr"
end

get "/todos/:id/edit" do |env|
  todo = Todo.find(env.params.url["id"].to_i64)

  if todo
    render "src/views/todos/edit.ecr", "src/views/layouts/application.ecr"
  else
    env.response.status_code = 404
    "Todo not found"
  end
end

post "/todos" do |env|
  title = env.params.body["title"]?.try(&.strip) || ""
  details = env.params.body["details"]?.try(&.strip) || ""

  Todo.create(title, details)
  env.redirect "/todos"
end

post "/todos/:id" do |env|
  todo = Todo.find(env.params.url["id"].to_i64)

  if todo
    title = env.params.body["title"]?.try(&.strip) || ""
    details = env.params.body["details"]?.try(&.strip) || ""
    completed = env.params.body["completed"]? == "true"

    todo.update(title, details, completed)
    env.redirect "/todos"
  else
    env.response.status_code = 404
    "Todo not found"
  end
end

post "/todos/:id/toggle" do |env|
  todo = Todo.find(env.params.url["id"].to_i64)

  if todo
    todo.toggle_completion
    env.redirect "/todos"
  else
    env.response.status_code = 404
    "Todo not found"
  end
end

post "/todos/:id/delete" do |env|
  todo = Todo.find(env.params.url["id"].to_i64)

  todo.try(&.delete)
  env.redirect "/todos"
end
