module TelegramQueryHandlers
  class GameType < ::TelegramQueryHandler
    private

    def perform_query
      query = ::GameQueries::ShowType.new(initiator: initiator, data: { id: params[:game_type_id] })
      game = ::GameQueryHandlers::ShowType.new(query).execute.message

      @message = {
        text: "#{game.game_data["assets"]["emoji"]}  *#{game.game_data["name"]}*\n\n_#{game.game_data["description"]}_",
        reply_markup: resized_keyboard(inline_keyboard: [[
                                                           { text: "Start New Game", callback_data: "start_game:room_id=#{params[:room_id]}&game_type_id=#{params[:game_type_id]}" },
                                                           { text: "Join Game", callback_data: "waiting_games_list:room_id=#{params[:room_id]}&game_type_id=#{params[:game_type_id]}" } ],
                                                         [
                                                           { text: "Back", callback_data: "game_types:room_id=#{params[:room_id]}" }
                                                         ]]),
        parse_mode: 'Markdown'
      }
    end
  end
end
