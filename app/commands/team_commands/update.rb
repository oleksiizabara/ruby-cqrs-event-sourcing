module TeamCommands
  class Update < ::Command
    attribute :initiator, Types::Any
    attribute :data do
      attribute :team_id, Types::Coercible::Integer
      attribute :name, Types::String
    end
  end
end
