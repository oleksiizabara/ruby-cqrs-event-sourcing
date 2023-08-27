module RoomCommandHandlers
  class Join < ::CommandHandler
    private

    def handle
      event = RoomEvents::UserJoined.new(type: 'UserJoined',
                                         data: { user_id: initiator.id,
                                                 room_id: data.room_id })

      EventStore::Store.publish('room', event)

      @success = true
    end
  end
end
