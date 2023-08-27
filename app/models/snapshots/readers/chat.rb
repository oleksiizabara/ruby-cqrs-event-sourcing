module Snapshots
  module Readers
    class Chat < Base
      def messages
        list_length = llen(key)

        data = if list_length <= 10
                 lrange(key, 0, -1)
               else
                 lrange(key, list_length - 10 , -1)
               end

        data.map do |msg|
          ::Snapshots::Entries::Message.new(JSON.parse(msg).deep_symbolize_keys)
        end
      end
    end
  end
end