module GameCommands
  class LeaveGame < ::Command
    attribute :initiator, Types::Instance(User)
    attribute :data do
      attribute :game_id, Types::Coercible::String
    end
  end
end
