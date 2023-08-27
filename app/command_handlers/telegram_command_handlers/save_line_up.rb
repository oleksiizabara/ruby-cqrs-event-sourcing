module TelegramCommandHandlers
  class SaveLineUp < ::TelegramCommandHandler
    private

    def handle
      text = "Line-up saved"
      buttons = [[{ text: 'Back', callback_data: "active_game:game_id=#{params[:game_id]}" }]]

      begin
        command = GameCommands::SaveLineUp.new(initiator: initiator, data: { game_id: params[:game_id] })
        ::GameCommandHandlers::SaveLineUp.new(command).perform
      rescue ::GameCommandHandlers::SaveLineUp::ValidationError => e
        text = e.message
        buttons = [[{ text: 'Back', callback_data: "set_starting_line_up:game_id=#{params[:game_id]}" }]]
      end

      @message = {
        text: text,
        reply_markup: resized_keyboard(inline_keyboard: buttons)
      }

      @success = true
    end
  end
end
