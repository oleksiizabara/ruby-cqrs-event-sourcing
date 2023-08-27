module TelegramQueryHandlers
  class GameFields < ::TelegramQueryHandler
    private

    DEFENSE_EMOJI = '🛡'
    FIGHT_EMOJI = '🏹'
    GOALIE_EMOJI = '🥅'
    GREEN_EMOJI = '🟢'
    RED_EMOJI = '🔴'

    ATTACK_STRATEGY_EMOJI = '⚡️'
    DEFENSE_STRATEGY_EMOJI = '⚔️'
    BONUS_EMOJI = '🎁'
    POISON_EMOJI = '☠️'

    def perform_query

    end

    def text
      "#{game_field.result}\n\n#{events}"
    end

    def refresh_button
      {
        text: 'Refresh',
        callback_data: "game_field:game_id=#{params[:game_id]}"
      }
    end

    def players


    end

    def bonuses
      {
        text: 'Bonuses',
        callback_data: "game_field_reply:#{params[:game_id]}&btn_type=bonuses"
      }
    end

    def strategies
      {
        text: 'Strategies',
        callback_data: "game_field_reply:#{params[:game_id]}&btn_type=strategies"
      }
    end

    def events
      game_field.events.map do |event|
        my_team = event.team_id == game_field.team.id
        emoji = my_team ? GREEN_EMOJI : RED_EMOJI

        prefix = if event.team_id.present?
                   team_name = my_team ? game_field.team.name : game_field.opponent.name

                   if event.player_id.present?
                     player_name = (my_team ? game_field.players[event.player_id]: game_field.opponents[event.player_id]).name
                      "#{emoji} #{player_name} from #{team_name}"
                   else
                     "#{emoji} #{team_name}"
                   end
                 else
                   game_field.game_type_data["other_events"][event.type]["assets"]["emoji"]
                 end

        "#{prefix} #{event.text}"
      end.join("\n")
    end

    def game_field
      @game_field ||=
        begin
          query = ::GameQueries::Field.new(initiator: initiator, data: { game_id: params[:game_id] })
          GameQueryHandlers::Field.new(query).execute.message
        end
    end
  end
end
