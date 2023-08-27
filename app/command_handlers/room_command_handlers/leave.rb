module RoomCommandHandlers
  class Leave < ::CommandHandler
    private

    def handle
      event = RoomEvents::UserLeft.new(type: 'UserLeft',
                                       data: { user_id: initiator.id,
                                               room_id: data.room_id })

      EventStore::Store.publish('room', event)

      @success = true
    end
  end
end
