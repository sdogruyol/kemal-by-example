get "/dashboard" do
  snapshots = MetricSnapshot.recent
  history_json = snapshots.map(&.to_payload).to_json

  render "src/views/dashboard/index.ecr", "src/views/layouts/application.ecr"
end

ws "/dashboard/socket" do |socket|
  RealTimeDashboard::MetricsHub.register(socket)

  socket.on_close do
    RealTimeDashboard::MetricsHub.unregister(socket)
  end
end
