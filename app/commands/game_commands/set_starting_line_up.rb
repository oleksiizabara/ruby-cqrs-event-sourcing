module GameCommands
  class SetStartingLineUp < ::Command
    attribute :initiator, Types::Instance(User)
    attribute :data do
      attribute :game_id, Types::Coercible::String
      attribute :player_id, Types::Coercible::String
      attribute :on_field, Types::Params::Bool
    end
  end
end
