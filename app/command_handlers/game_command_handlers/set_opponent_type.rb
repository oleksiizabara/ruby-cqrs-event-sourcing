module GameCommandHandlers
  class SetOpponentType < ::CommandHandler
    private

    def handle
      Game.transaction do
        case data.opponent_type
        when 'bot'
          game.guest_team_id = bot_team.id
          game.with_bot = true
          game.guest_user_id = bot.id

          cache_bot_team
          status = Game::IN_PROGRESS

          publish_game_started_event
        when 'player'
          status = Game::WAITING_FOR_OPPONENT
        else
          return
        end

        game.status = status
        game.save!
      end

      @success = true
    end

    def publish_game_started_event
      event = ::GameEvents::GameStarted.new(type: "GameStarted", data: { game_id: game.id, started_at: Time.now })

      ::EventStore::Store.publish("game", event)
    end

    def cache_bot_team
      recorder = Snapshots::Recorders::Game.new(game.id)

      team_entry = Snapshots::Entries::Team.new(id: bot_team.id, name: bot_team.name, user_id: bot_team.user_id, bot: true, home: false)
      recorder.team(team_entry)

      bot_players.each do |player|
        on_field = players_counts[player.sub_position] > 0

        player_entry = Snapshots::Entries::Player.new(id: player.id, team_id: player.team_id, name: player.name,
                                                      number: player.number, position: player.position,
                                                      sub_position: player.sub_position, on_field: on_field,
                                                      location: game_type_data.game_data["players"]["types"][player.sub_position]["game_start_position"],
                                                      stats: { offense: player.offense, defense: player.defense,
                                                               stamina: player.stamina, speed: player.speed,
                                                               morale: player.morale, health: player.health },
                                                      coordinates: { x: 0, y: 0 })
        recorder.player(player_entry)

        players_counts[player.sub_position] -= 1 if on_field
      end
    end

    def bot_players
      Player.where(team_id: bot_team.id)
    end

    def bot_team
      @team = begin
                query = TeamQueries::Show.new(initiator: bot, data: { game_type_id: game.game_type_id })
                ::TeamQueryHandlers::Show.new(query).execute.message
              end
    end

    def bot
      @bot ||= Bot.first
    end

    def players_counts
      @players_counts ||= ::GameType.find(game.game_type_id).game_data["players"]["types"].each_with_object({}) do |(sub_position, info), hash|
        hash[sub_position] = info["count_on_field"].to_i
      end
    end

    def game
      @game ||= Game.find(data.game_id)
    end

    def game_type_data
      @game_type_data ||= ::GameType.find(game.game_type_id)
    end
  end
end
