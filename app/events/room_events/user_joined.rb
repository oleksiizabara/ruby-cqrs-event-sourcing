module RoomEvents
  class UserJoined < ::BaseEvent
    attribute :type, Types::Coercible::String
    attribute :data do
      attribute :user_id, Types::Coercible::String
      attribute :room_id, Types::Coercible::String
    end
  end
end
