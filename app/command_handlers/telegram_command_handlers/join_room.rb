module TelegramCommandHandlers
  class JoinRoom < ::TelegramCommandHandler
    private

    def handle
      command = RoomCommands::Join.new(initiator: initiator, data: { room_id: params[:room_id] })
      RoomCommandHandlers::Join.new(command).perform

      @message = {
        text: "You have joined the room *#{room.room_name}*",
        reply_markup: resized_keyboard(inline_keyboard: [[{ text: 'Chat', callback_data: "chat:room_id=#{params[:room_id]}" },
                                                          { text: 'Games', callback_data: "game_types:room_id=#{params[:room_id]}" } ],
                                                         [{ text: 'Back', callback_data: "leave_room:room_id=#{params[:room_id]}" }] ]),
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