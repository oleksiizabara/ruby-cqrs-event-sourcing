module Snapshots
  module Recorders
    class Chat < Base
      def add_message(message)
        rpush(key, message.to_json)
        ltrim(key, -10, -1)
      end
    end
  end
end
