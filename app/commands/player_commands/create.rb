module PlayerCommands
  class Create < ::Command
    attribute :initiator, Types::Any
    attribute :data do
      attribute :name, Types::String
      attribute :number, Types::Coercible::Integer
      attribute :position, Types::String
      attribute :team_id, Types::Coercible::String
      attribute :sub_position, Types::String
      attribute :game_type_id, Types::Coercible::String
    end
  end
end