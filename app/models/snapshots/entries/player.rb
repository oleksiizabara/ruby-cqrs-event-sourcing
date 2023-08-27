module Snapshots
  module Entries
    class Player < Entry
      attribute :id, Types::Coercible::String
      attribute :team_id, Types::Coercible::String
      attribute :name, Types::Coercible::String
      attribute :number, Types::Coercible::String
      attribute :position, Types::Coercible::String
      attribute :sub_position, Types::Coercible::String
      attribute :location, Types::Coercible::String
      attribute :available_at, (Types::Params::DateTime | Types::Params::Time).default(Time.zone.now)
      attribute :color, Types::Coercible::String.default(nil)
      attribute :on_field, Types::Params::Bool.default(false)
      attribute :stats do
        attribute :offense, Types::Coercible::Integer
        attribute :defense, Types::Coercible::Integer
        attribute :stamina, Types::Coercible::Integer
        attribute :speed, Types::Coercible::Integer
        attribute :morale, Types::Coercible::Integer
        attribute :health, Types::Coercible::Integer
      end
      attribute :coordinates do
        attribute :x, Types::Coercible::Integer.default(0)
        attribute :y, Types::Coercible::Integer.default(0)
      end
    end
  end
end
