module TelegramQueryHandlers
  class WaitingGamesList < ::TelegramQueryHandler
    private

    def perform_query
      @message = {
        text: waiting_opponent_games.empty? ? "No games available" : "Choose one of the opponents below to start a game:",
        reply_markup: resized_keyboard(inline_keyboard: buttons),
        parse_mode: 'Markdown'
      }
    end

    def buttons
      @buttons ||=
        begin
          games = waiting_opponent_games.map do |game|
            [{ text: "#{game.game_data["assets"]["emoji"]} #{game.home_team_name}",
               callback_data: "join_game:room_id=#{params[:room_id]}&game_id=#{game.id}" }]
          end

          games + [[ { text: "Back", callback_data: "game_types:room_id=#{params[:room_id]}" }]]
        end
    end

    def waiting_opponent_games
      @waiting_opponent_games ||=
        begin
          query = ::GameQueries::ListWaitingOpponent.new(initiator: initiator, data: { room_id: params[:room_id], game_type_id: params[:game_type_id] })
          ::GameQueryHandlers::ListWaitingOpponent.new(query).execute.message
        end
    end
  end
end
