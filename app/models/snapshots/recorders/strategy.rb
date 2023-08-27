module Snapshots
  module Recorders
    class Strategy < Base
      def save(strategy)
        hset(key, strategy.id, strategy.to_json)
      end

      def clear(id)
        hdel(key, id)
      end
    end
  end
end
