module TelegramQueryHandlers
  class GameTypes < ::TelegramQueryHandler
    private

    def perform_query
      query = ::GameQueries::ListTypes.new(initiator: initiator, data: { room_id: params[:room_id] })

      games = ::GameQueryHandlers::ListTypes.new(query).execute.message.map do |game|
        [{ text: "#{game.game_data["assets"]["emoji"]}  #{game.game_data["name"]}",
           callback_data: "game_type:room_id=#{params[:room_id]}&game_type_id=#{game.id}" }]
      end

      @message = {
        text: games.empty? ? "No games available" : "Choose game type",
        reply_markup: resized_keyboard(inline_keyboard: games + [[ { text: "Create New Game", callback_data: "create_game:room_id=#{params[:room_id]}" }], [
                                                                   { text: "Back", callback_data: "room:room_id=#{params[:room_id]}" }]]),
        parse_mode: 'Markdown'
      }
    end
  end
end
