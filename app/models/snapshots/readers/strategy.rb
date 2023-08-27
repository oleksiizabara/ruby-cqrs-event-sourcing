module Snapshots
  module Readers
    class Strategy < Base
      def find(id)
        all[id]
      end

      def all
        @all ||=
          begin
            hgetall(key).each_with_object({}) do |(id, strategy), strategies|
              strategies[id.to_i] = ::Snapshots::Entries::Strategy.new(JSON.parse(strategy).deep_symbolize_keys)
            end
          end
      end
    end
  end
end
