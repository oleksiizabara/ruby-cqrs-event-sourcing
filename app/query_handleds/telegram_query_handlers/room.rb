module TelegramQueryHandlers
  class Room < ::TelegramQueryHandler
    private

    def perform_query
      @message = {
        text: "Room: *#{room.room_name}* (players: *#{room.users_count}*",
        reply_markup: resized_keyboard(inline_keyboard: [[{ text: 'Chat', callback_data: "chat:room_id=#{params[:room_id]}" },
                                                          { text: 'Games', callback_data: "game_types:room_id=#{params[:room_id]}" } ],
                                                         [{ text: 'Back', callback_data: "leave_room:room_id=#{params[:room_id]}" }] ]),
        parse_mode: "Markdown"

      }
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