module TeamCommands
  class Create < ::Command
    attribute :initiator, Types.Instance(::User)
    attribute :data do
      attribute :name, Types::String
      attribute :game_type_id, Types::Coercible::String
    end
  end
end
