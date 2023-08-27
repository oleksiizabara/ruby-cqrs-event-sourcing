module TelegramCommandHandlers
  class StartGame < ::TelegramCommandHandler
    private

    def handle
      begin
        command = GameCommands::Start.new(initiator: initiator, data: { room_id: params[:room_id],
                                                                        game_type_id: params[:game_type_id] })
        result = ::GameCommandHandlers::Start.new(command).perform

        @message = {
          text: result.message,
          reply_markup: resized_keyboard(inline_keyboard: [[{ text: 'To Game', callback_data: "active_game:room_id=#{params[:room_id]}&game_type_id=#{params[:game_type_id]}" },
                                                            { text: 'Back', callback_data: "cancel_game:room_id=#{params[:room_id]}&game_type_id=#{params[:game_type_id]}" }]])
        }

      rescue ::GameCommandHandlers::Start::DontHaveTeamError
        @message = {
          text: "You don't have a team. Create a team first.",
          reply_markup: resized_keyboard(inline_keyboard: [[{ text: 'Create Team', callback_data: "create_team:room_id=#{params[:room_id]}&game_type_id=#{params[:game_type_id]}" },
                                                            { text: 'Back', callback_data: "game_type:room_id=#{params[:room_id]}&game_type_id=#{params[:game_type_id]}" }]])
        }

      rescue ::GameCommandHandlers::Start::UncompletedTeamError
        @message = {
          text: "Your team is not completed. Complete your team first.",
          reply_markup: resized_keyboard(inline_keyboard: [[{ text: 'Complete Team', callback_data: "team:room_id=#{params[:room_id]}&game_type_id=#{params[:game_type_id]}" },
                                                            { text: 'Back', callback_data: "game_type:room_id=#{params[:room_id]}&game_type_id=#{params[:game_type_id]}" }]])
        }
      end

      @success = true
    end
  end
end
