module TelegramCommandHandlers
  class CreateTeam < ::TelegramCommandHandler
    private

    def handle
      if with_context
        begin
          command = TeamCommands::Create.new(initiator: initiator, data: { name: callback_message, game_type_id: session[:params][:game_type_id] })
          TeamCommandHandlers::Create.new(command).perform

          @message = {
            text: "Team #{callback_message} has been created",
            reply_markup: resized_keyboard(inline_keyboard: [[{ text: "Teams",
                                                                callback_data: "teams:room_id=#{session[:params][:room_id]}&game_type_id=#{session[:params][:game_type_id]}" }]]),
            parse_mode: 'Markdown'
          }
        rescue ::TeamCommandHandlers::Create::InvalidTeamParams => e
          @message = {
            text: e.message,
            reply_markup: resized_keyboard(inline_keyboard: [[{ text: "Back",
                                                                callback_data: "game_type:room_id=#{session[:params][:room_id]}&game_type_id=#{session[:params][:game_type_id]}" }]])
          }

        end
      else
        @message = {
          text: "Choose team name:",
          reply_markup: resized_keyboard(inline_keyboard: [[ { text: "Cancel",
                                                              callback_data: "game_type:room_id=#{params[:room_id]}&game_type_id=#{params[:game_type_id]}" }]])
        }

        session[:params] = params
      end

      @success = true
    end
  end
end
