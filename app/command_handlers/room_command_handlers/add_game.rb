module RoomCommandHandlers
  class AddGame < ::CommandHandler
    private

    def handle
      room = Room.find(command.room_id)
      room.add_game(command.game_id)
      room.save!

      @success = true
    rescue Room::InvalidGame => e
      @errors << e.message
    end
  end
end
