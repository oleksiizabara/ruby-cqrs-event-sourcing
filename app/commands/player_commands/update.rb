module PlayerCommands
  class Update < ::Command
    attribute :initiator, Types::Any
    attribute :data do
      attribute :player_id, Types::Coercible::Integer
      attribute :name, Types::String
      attribute :number, Types::Coercible::Integer
      attribute :position, Types::String
      attribute :defense, Types::Coercible::Integer
      attribute :offense, Types::Coercible::Integer
      attribute :speed, Types::Coercible::Integer
      attribute :stamina, Types::Coercible::Integer
      attribute :health, Types::Coercible::Integer
      attribute :morale, Types::Coercible::Integer
    end
  end
end
