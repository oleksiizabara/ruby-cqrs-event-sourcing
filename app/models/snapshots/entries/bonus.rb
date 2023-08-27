module Snapshots
  module Entries
    class Bonus < Entry
      attribute :id, Types::Coercible::String
      attribute :name, Types::Coercible::String
      attribute :affect_home_team, Types::Coercible::String
      attribute :duration, Types::Coercible::Integer
      attribute :stats_delta do
        attribute :offense, Types::Coercible::Integer
        attribute :defense, Types::Coercible::Integer
        attribute :stamina, Types::Coercible::Integer
        attribute :speed, Types::Coercible::Integer
        attribute :morale, Types::Coercible::Integer
        attribute :health, Types::Coercible::Integer
      end
    end
  end
end
