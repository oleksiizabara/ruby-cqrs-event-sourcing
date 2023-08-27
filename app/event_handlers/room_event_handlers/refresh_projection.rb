module RoomEventHandlers
  class RefreshProjection < ::EventHandler
    def handle
      sleep 30

      command = ::RoomCommands::RefreshProjection.new(data: { room_id: data.room_id })
      ::RoomCommandHandlers::RefreshProjection.new(command).perform

      new_event = RoomEvents::RefreshProjection.new(type: 'RefreshProjection', data: { room_id: data.room_id })
      EventStore::Store.publish('room', new_event)
    end
  end
end
