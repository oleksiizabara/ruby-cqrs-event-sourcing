module RoomCommands
  class Join < ::Command
    attribute :initiator, Types::Any
    attribute :data do
      attribute :room_id, Types::Coercible::Integer
    end
  end
end
