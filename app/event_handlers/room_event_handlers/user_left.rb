module RoomEventHandlers
  class UserLeft < ::EventHandler
    def handle
      Event.create!(event_type: event.type, room_id: data.room_id, data: { user_id: data.user_id })
    end
  end
end
