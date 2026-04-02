module RealTimeDashboard
  module MetricsHub
    extend self

    @@mutex = Mutex.new
    @@sockets = [] of HTTP::WebSocket
    @@channel = Channel(MetricSnapshot).new
    @@started = false

    def start
      should_start = @@mutex.synchronize do
        next false if @@started
        @@started = true
        true
      end

      return unless should_start

      spawn do
        loop do
          @@channel.send(SystemMetrics.collect)
          sleep 1.second
        end
      end

      spawn do
        loop do
          snapshot = @@channel.receive
          stored_snapshot = MetricSnapshot.record(
            snapshot.cpu_percent,
            snapshot.memory_percent
          )
          MetricSnapshot.prune
          broadcast_snapshot(stored_snapshot)
        end
      end
    end

    def register(socket : HTTP::WebSocket)
      @@mutex.synchronize do
        @@sockets << socket
      end
    end

    def unregister(socket : HTTP::WebSocket)
      @@mutex.synchronize do
        @@sockets.delete(socket)
      end
    end

    private def broadcast_snapshot(snapshot : MetricSnapshot)
      message = {
        event:    "metric_snapshot",
        snapshot: snapshot.to_payload,
      }.to_json

      sockets = @@mutex.synchronize { @@sockets.dup }

      sockets.each do |socket|
        begin
          socket.send(message)
        rescue
          unregister(socket)
        end
      end
    end
  end
end
