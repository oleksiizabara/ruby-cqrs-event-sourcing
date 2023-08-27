module Snapshots
  module Recorders
    class Bonus < Base
      def save(bonus)
        hset(key, bonus.id, bonus.to_json)
      end

      def clear(id)
        hdel(key, id)
      end
    end
  end
end
