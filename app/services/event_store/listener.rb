module EventStore
  class Listener
    def initialize(channel, redis:)
      @channel = channel
      @redis = redis
    end

    def listen
      redis.subscribe(channel) do |on|
        Rails.logger.info "Listening to #{channel}"

        on.message do |_, message|
          Rails.logger.info "Received message #{message}"

          Thread.new do
            parsed_message = JSON.parse(message).deep_symbolize_keys

            event = "#{channel.classify}Events::#{parsed_message[:type]}".constantize.new(parsed_message)
            "#{channel.classify}EventHandlers::#{parsed_message[:type]}".constantize.new(event).handle
          end
        end
      end
    end

    private

    attr_reader :channel, :redis
  end
end
