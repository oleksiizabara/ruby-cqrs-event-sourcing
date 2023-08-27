module RoomCommandHandlers
  class Create < ::CommandHandler
    class InvalidRoomPramsError < ::CommandHandler::Error; end

    private

    def handle
      room = Room.new(name: data.name, owner_id: initiator.id)
      room.save!

      RoomProjection.create!(room_id: room.id, users_count: 1)

      event = RoomEvents::RefreshProjection.new(type: 'RefreshProjection', data: { room_id: room.id })
      EventStore::Store.publish('room', event)

      @message = "Room #{room.name} successfully created!"
      @success = true
    rescue ActiveRecord::RecordInvalid => e
      raise InvalidRoomPramsError, e.message
    end
  end
end
