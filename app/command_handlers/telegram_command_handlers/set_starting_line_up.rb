module TelegramCommandHandlers
  class SetStartingLineUp < ::TelegramCommandHandler
    private

    def handle
      update_player

      @message = {
        text: "Choose Starting Line-up",
        reply_markup: resized_keyboard(inline_keyboard: buttons)
      }

      @success = true
    end

    def update_player
      return unless params[:player_id]

      command = GameCommands::SetStartingLineUp.new(initiator: initiator, data: { game_id: params[:game_id],
                                                                                  player_id: params[:player_id],
                                                                                  on_field: params[:action] == 'add' })
      ::GameCommandHandlers::SetStartingLineUp.new(command).perform
    end

    def buttons
      buttons = []

      players.each do |_, player|
        on_field = player.on_field

        emoji = on_field ? '✅' : '❌'
        action = on_field ? 'remove' : 'add'

        text = "#{emoji} #{player.name} (#{player.sub_position})"

        buttons << { text: text, callback_data: "set_starting_line_up_reply:game_id=#{params[:game_id]}&player_id=#{player.id}&action=#{action}" }
      end
      buttons = buttons.each_slice(2).to_a

      buttons << [{ text: 'Back', callback_data: "active_game:game_id=#{params[:game_id]}" },
                  { text: 'Save', callback_data: "save_line_up:game_id=#{params[:game_id]}" }]
      buttons
    end

    def players
      @players ||= begin
                     query = GameQueries::TeamPlayers.new(initiator: initiator, data: { game_id: params[:game_id] })
                      ::GameQueryHandlers::TeamPlayers.new(query).execute.message
                   end
    end
  end
end
