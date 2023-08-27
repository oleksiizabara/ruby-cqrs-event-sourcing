module RoomCommands
  class Remove < ::Command
    attribute :initiator, Types::Any
    attribute :data do
      attribute :room_id, Types::Coercible::Integer
    end
  end
end
