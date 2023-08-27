module GameCommands
  class SetOpponentType < ::Command
    attribute :initiator, Types::Instance(User)
    attribute :data do
      attribute :game_id, Types::Coercible::String
      attribute :opponent_type, Types::Coercible::String
    end
  end
end