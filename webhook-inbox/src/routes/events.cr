require "../models/webhook_event"

get "/events/:id" do |env|
  id = env.params.url["id"].to_i64?
  unless id
    env.response.status_code = 400
    next "Invalid id"
  end

  event = WebhookEvent.find(id)
  unless event
    env.response.status_code = 404
    next "Not found"
  end

  render "src/views/inbox/show.ecr", "src/views/layouts/application.ecr"
end
