module TelegramCommandHandlers
  class JoinGame < ::TelegramCommandHandler
    private

    def handle
      begin
        command = GameCommands::JoinGame.new(initiator: initiator, data: { game_id: game.id })
        result = ::GameCommandHandlers::JoinGame.new(command).perform

        @message = {
          text: result.message,
          reply_markup: resized_keyboard(inline_keyboard: [[{ text: 'To Game', callback_data: "active_game:room_id=#{game.room_id}&game_type_id=#{game.game_type_id}" },
                                                            { text: 'Back', callback_data: "games:room_id=#{game.room_id}&game_type_id=#{game.game_type_id}" }]])
        }

      rescue ::GameCommandHandlers::JoinGame::DontHaveTeamError
        @message = {
          text: "You don't have a team. Create a team first.",
          reply_markup: resized_keyboard(inline_keyboard: [[{ text: 'Create Team', callback_data: "create_team:room_id=#{game.room_id}&game_type_id=#{game.game_type_id}" },
                                                            { text: 'Back', callback_data: "game_type:room_id=#{game.room_id}&game_type_id=#{game.game_type_id}" }]])
        }

      rescue ::GameCommandHandlers::JoinGame::UncompletedTeamError
        @message = {
          text: "Your team is not completed. Complete your team first.",
          reply_markup: resized_keyboard(inline_keyboard: [[{ text: 'Complete Team', callback_data: "team:room_id=#{game.room_id}&game_type_id=#{params[:game_type_id]}" },
                                                            { text: 'Back', callback_data: "game_type:room_id=#{game.room_id}&game_type_id=#{game.game_type_id}" }]])
        }
      end

      @success = true
    end
    
    def game
      @game ||= Game.find(params[:game_id])
    end
  end
end
