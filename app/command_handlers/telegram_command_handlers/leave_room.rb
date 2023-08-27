module TelegramCommandHandlers
  class LeaveRoom < ::TelegramCommandHandler
    private

    def handle
      command = RoomCommands::Leave.new(initiator: initiator, data: { room_id: params[:room_id] })
      RoomCommandHandlers::Leave.new(command).perform

      @message = {
        text: "You have left the room *#{room.room_name}*",
        reply_markup: resized_keyboard(inline_keyboard: [[ { text: "Rooms", callback_data: 'rooms' },
                                                           { text: "New Room", callback_data: 'new_room' } ]]),
        parse_mode: 'Markdown'
      }

      @success = true
    end

    def room
      @room ||=
        begin
          query = RoomQueries::Show.new(initiator: initiator, data: { room_id: params[:room_id] })
          RoomQueryHandlers::Show.new(query).execute.message
        end
    end
  end
end