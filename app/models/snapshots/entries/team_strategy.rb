module Snapshots
  module Entries
    class TeamStrategy < Entry
      attribute :id, Types::Coercible::String
      attribute :team_id, Types::Coercible::String
      attribute :name, Types::Coercible::String
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
