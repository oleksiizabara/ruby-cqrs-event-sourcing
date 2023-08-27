module GameCommands
  class Start < ::Command
    attribute :initiator, Types.Instance(::User)
    attribute :data do
      attribute :room_id, Types::Coercible::String
      attribute :game_type_id, Types::Coercible::String
    end
  end
end
