module Snapshots
  module Entries
    class Strategy < Entry
      attribute :id, Types::Coercible::String
      attribute :name, Types::Coercible::String
      attribute :description, Types::Coercible::String
      attribute :stats_delta do
        attribute :offense, Types::Coercible::Integer
        attribute :defense, Types::Coercible::Integer
      end
    end
  end
end
