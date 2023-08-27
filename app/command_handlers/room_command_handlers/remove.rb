module RoomCommandHandlers
  class Remove < ::CommandHandler
    private

    def handle
      room = Room.find(command.room_id)
      room.remove(command.user_id)
      room.save!

      @success = true
    rescue Room::InvalidUser => e
      @errors << e.message
    end
  end
end
