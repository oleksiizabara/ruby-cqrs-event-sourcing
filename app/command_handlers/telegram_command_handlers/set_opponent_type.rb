module TelegramCommandHandlers
  class SetOpponentType < ::TelegramCommandHandler
    private

    def handle
      command = GameCommands::SetOpponentType.new(initiator: initiator,
                                                  data: { game_id: params[:game_id],
                                                          opponent_type: params[:type] })
      GameCommandHandlers::SetOpponentType.new(command).perform

      @success = true

      text = params[:type] == 'bot' ? "Play against bot!" : "Wait for opponent."
      @message = {
        text: "Done! #{text}",
        reply_markup: resized_keyboard(inline_keyboard: [[{ text: 'To game', callback_data: "active_game:id=#{params[:game_id]}" }]])
      }
    end
  end
end
