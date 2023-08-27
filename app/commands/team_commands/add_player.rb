module TeamCommands
  class AddPlayer < ::Command
    attribute :initiator, Types::Any
    attribute :data do
      attribute :team_id, Types::Coercible::Integer
      attribute :player_id, Types::Coercible::Integer
    end
  end
end
