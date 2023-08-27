module RoomEvents
  class RefreshProjection < ::BaseEvent
    attribute :type, Types::Coercible::String
    attribute :data do
      attribute :room_id, Types::Coercible::Integer
    end
  end
end
