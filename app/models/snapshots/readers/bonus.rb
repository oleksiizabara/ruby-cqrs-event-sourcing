module Snapshots
  module Readers
    class Bonus < Base
      def find(id)
        all[id]
      end

      def all
        @all ||=
          begin
            hgetall(key).each_with_object({}) do |(id, bonus), bonuses|
              bonuses[id.to_i] = ::Snapshots::Entries::Bonus.new(JSON.parse(bonus).deep_symbolize_keys)
            end
          end
      end
    end
  end
end
