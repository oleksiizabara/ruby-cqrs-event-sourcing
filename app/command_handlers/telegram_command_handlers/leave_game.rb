module TelegramCommandHandlers
  class LeaveGame < ::TelegramCommandHandler
    private

    def handle
      command = ::GameCommands::LeaveGame.new(initiator: initiator, data: { game_id: params[:game_id] })
      ::GameCommandHandlers::LeaveGame.new(command).perform

      @message = {
        text: "You have left the game! Game results will be ready soon.",
        reply_markup: resized_keyboard(inline_keyboard: [[ { text: "Game Results", callback_data: "game_results:game_id=#{params[:game_id]}" },
                                                           { text: "Games", callback_data: "game_type:room_id=#{game.room_id}&game_type_id=#{game.game_type_id}" } ]]),
        parse_mode: 'Markdown'
      }

      @success = true
    end

    def game
      @game ||= Game.find(params[:game_id])
    end
  end
end