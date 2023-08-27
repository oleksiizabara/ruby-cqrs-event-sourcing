module EventStore
  class Publisher
    def initialize(channel, redis:)
      @channel = channel
      @redis = redis
    end

    def publish(event)
      Thread.new do
        redis.publish(channel, JSON.generate(event.to_hash))
      end
    end

    private

    attr_reader :channel, :redis
  end
end

# $redis.publish('telegram_profile', JSON.generate(event.to_hash))
