module TwitterClone
  module Realtime
    extend self

    @@sockets = [] of HTTP::WebSocket
    @@mutex = Mutex.new

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

    def broadcast_tweet_created(tweet : Tweet)
      broadcast({
        event: "tweet_created",
        tweet: tweet_payload(tweet),
      }.to_json)
    end

    def broadcast_tweet_updated(tweet : Tweet)
      broadcast({
        event: "tweet_updated",
        tweet: tweet_payload(tweet),
      }.to_json)
    end

    def broadcast_tweet_liked(tweet : Tweet)
      broadcast({
        event: "tweet_liked",
        tweet: tweet_payload(tweet),
      }.to_json)
    end

    def broadcast_tweet_deleted(tweet_id : Int64)
      broadcast({
        event: "tweet_deleted",
        tweet_id: tweet_id,
      }.to_json)
    end

    private def broadcast(message : String)
      sockets = @@mutex.synchronize { @@sockets.dup }

      sockets.each do |socket|
        begin
          socket.send(message)
        rescue
          unregister(socket)
        end
      end
    end

    private def tweet_payload(tweet : Tweet)
      {
        id: tweet.id,
        display_name: tweet.display_name,
        username: tweet.username,
        handle: tweet.handle,
        body: tweet.body,
        likes_count: tweet.likes_count,
        created_at: tweet.created_at,
        updated_at: tweet.updated_at,
      }
    end
  end
end
