module TelegramQueryHandlers
  class Team < ::TelegramQueryHandler
    private

    def perform_query
      session[:player] = nil

      @message = {
        text: "Players",
        reply_markup: resized_keyboard(inline_keyboard: keyboard + additional_buttons),
        parse_mode: 'Markdown'
      }
    end

    def additional_buttons
      buttons = [[{ text: 'Back', callback_data: "games:room_id=#{params[:room_id]}" }]]
      buttons << [{ text: 'Join Game', callback_data: "waiting_games_list:room_id=#{params[:room_id]}&game_type_id=#{game_type_id}" }] if team.completed?
      buttons
    end

    def keyboard
      players.map do |player_type, player_type_data|
        player_type_data[:players].map.with_index do |player, index|
          if player[:id].nil?
            {
              text: "Create #{player_type_data[:name]} #{index + 1}",
              callback_data: "create_player:team_id=#{team.id}&p=#{player[:position]}&s=#{player_type}&room_id=#{params[:room_id]}&t=#{game_type_id}"
            }
          else
            {
              text: "#{player_type_data[:emoji]} #{player[:name]}, score: #{player[:max_stat]}",
              callback_data: "player:id=#{player[:id]}&team_id=#{team.id}&room_id=#{params[:room_id]}",
              selective: false
            }
          end
        end
      end.flatten.each_slice(2).to_a
    end

    def players
      @players = team_players_sceleton.each_with_object({}) do |(sub_position, player_type_data), hash|
        hash[sub_position] = {
          name: player_type_data[:name],
          emoji: player_type_data[:emoji],

          players: player_type_data[:max_count].times.map do |index|
            player = team_players.dig(sub_position, index)
            if player.nil?
              {
                sub_position: sub_position,
                position: player_type_data[:position],
              }
            else
              {
                id: player.id,
                name: player.name,
                number: player.number,
                max_stat: player.max_stat
              }
            end
          end
        }
      end
    end

    def team_players
      @team_players ||=
        begin
          query = PlayerQueries::List.new(initiator: initiator, data: { team_id: team.id })
          PlayerQueryHandlers::List.new(query).execute.message
        end.group_by(&:sub_position)
    end

    def team_players_sceleton
      @team_players_sceleton ||= team.game_team_data["players"]["types"].each_with_object({}) do |(identifier, info), hash|
        hash[identifier] = {
          name: info["name"],
          position: info["type"],
          max_count: info["max_count"],
          emoji: info["assets"]["emoji"]
        }
      end
    end

    def team
      @team ||=
        begin
          query = TeamQueries::Show.new(initiator: initiator, data: { id: params[:team_id],
                                                                      game_type_id: params[:game_type_id] })
          TeamQueryHandlers::Show.new(query).execute.message
        end
    end

    def game_type_id
      params[:game_type_id] || team.game_type_id
    end
  end
end
