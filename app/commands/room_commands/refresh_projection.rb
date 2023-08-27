module RoomCommands
  class RefreshProjection < ::Command
    attribute :data do
      attribute :room_id, Types::Coercible::Integer
    end
  end
end
