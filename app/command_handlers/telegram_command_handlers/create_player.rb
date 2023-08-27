module TelegramCommandHandlers
  class CreatePlayer < ::TelegramCommandHandler
    private

    def handle
      set_player_session

      if session_params[:player_attribute] == "save"
          PlayerCommandHandlers::Create.new(player_create_command).perform

          update_team

          @message = {
            text: "Player successfully created!",
            reply_markup: resized_keyboard(inline_keyboard: [[{ text: 'Back', callback_data: "team:room_id=#{session_params[:room_id]}&team_id=#{session_params[:team_id]}&game_type_id=#{session_params[:game_type_id]}" }] ]),
            parse_mode: 'Markdown'
          }
      else
        if session_params[:player_attribute].present? && callback_message.present?
          saved_attribute = session_params[:player_attribute]

          session_params[saved_attribute.to_sym] = callback_message
          delete_message
        end

        text = if session_params[:player_attribute].present?
                  "Enter player #{session_params[:player_attribute]}:"
                else
                  "Create player:"
               end

        save_button = if can_save?
                        [{ text: "Save", callback_data: "create_player:room_id=#{session_params[:room_id]}&team_id=#{session_params[:team_id]}&player_attribute=save" }]
                      else
                        []
                      end
        @message = {
          text: text,
          reply_markup: resized_keyboard(inline_keyboard: [
            [{ text: command_name_with_status("Name"),
               callback_data: "create_player:room_id=#{session_params[:room_id]}&team_id=#{session_params[:team_id]}&player_attribute=name" },
             { text: command_name_with_status("Number"),
               callback_data: "create_player:room_id=#{session_params[:room_id]}&team_id=#{session_params[:team_id]}&player_attribute=number" }],
            [{ text: "Back", callback_data: "team:room_id=#{session_params[:room_id]}&team_id=#{session_params[:team_id]}&game_type_id=#{session_params[:game_type_id]}" }] + save_button ]),
          parse_mode: "Markdown"
        }
      end

      @success = true
    end

    def selective?(command_name)
      session_params[command_name.downcase.to_sym].blank?
    end

    def command_name_with_status(command_name)
      if selective?(command_name)
        emoji_not_done = "\u{274C}"
        "#{emoji_not_done} #{command_name}"
      else
        emoji_done = "\u{2705}"
        "#{emoji_done} #{command_name}: #{session_params[command_name.downcase.to_sym]}"
      end
    end

    def set_player_session
      session[:player] ||= {}
      session[:player][:params] ||= params
      session[:player][:params].merge!(params)
      session[:player][:params][:position] ||= params[:p]
      session[:player][:params][:sub_position] ||= params[:s]
      session[:player][:params][:game_type_id] ||= params[:t]
    end

    def session_params
      session[:player][:params]
    end

    def can_save?
      session_params[:name].present? && session_params[:number].present?
    end

    def update_team
      if team.game_team_data["players"]["max_count"] == team_players.count('*')
        Team.update(team.id, completed: true)
      end
    end

    def player_create_command
      @player_create_command ||= PlayerCommands::Create.new(initiator: initiator,
                                                            data: {
                                                              name: session_params[:name],
                                                              number: session_params[:number],
                                                              team_id: session_params[:team_id],
                                                              position: session_params[:position],
                                                              sub_position: session_params[:sub_position],
                                                              game_type_id: session_params[:game_type_id]
                                                            })
    end

    def team
      @team ||= begin
                  query = TeamQueries::Show.new(initiator: initiator, data: { id: session_params[:team_id] })
                  TeamQueryHandlers::Show.new(query).execute.message
                end
    end

    def team_players
      @team_players ||= begin
                          query = PlayerQueries::List.new(initiator: initiator, data: { team_id: session_params[:team_id] })
                          PlayerQueryHandlers::List.new(query).execute.message
                        end
    end
  end
end
