module TelegramQueryHandlers
  class Rooms < ::TelegramQueryHandler
    private

    def perform_query
      query = RoomQueries::List.new(initiator: initiator, data: { page: 1 })
      rooms = RoomQueryHandlers::List.new(query).execute.message

      @message = {
        text: 'Rooms:',
        reply_markup: resized_keyboard(
          inline_keyboard: rooms.map do |room|
            [
              {
                text: "#{room.room_name} (players: #{room.users_count})",
                callback_data: "join_room:room_id=#{room.room_id}"
              }
            ]
          end + [[{ text: 'Create room', callback_data: 'new_room' },
                  { text: 'Back', callback_data: 'start_reply' }]]
        )
      }
    end
  end
end