require 'event_store/listener'
require 'event_store/publisher'

module EventStore
  class Store
    extend Dry::Configurable

    setting :channels, reader: true, default: []
    setting :redis_url, reader: true

    class << self
      def publish(channel, event)
        publisher(channel).publish(event)
      end

      def listen
        listeners.each { |listener| puts listener; Thread.new { listener.listen } }
      end

      private

      def listeners
        channels.map { |channel| ::EventStore::Listener.new(channel, redis: Redis.new(url: redis_url)) }
      end

      def publisher(channel)
        ::EventStore::Publisher.new(channel, redis: Redis.new(url: redis_url))
      end
    end
  end
end
