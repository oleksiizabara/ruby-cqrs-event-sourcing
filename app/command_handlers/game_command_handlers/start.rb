module GameCommandHandlers
  class Start < ::CommandHandler
    class DontHaveTeamError < ::CommandHandler::Error; end
    class UncompletedTeamError < ::CommandHandler::Error; end
    class ActiveGameError < ::CommandHandler::Error; end

    private

    def handle
      raise DontHaveTeamError if team.nil?
      raise UncompletedTeamError unless team.completed?
      raise ActiveGameError if game.present?

      Game.transaction do
        game = ::Game.create!(home_user_id: initiator.id,
                              home_team_id: team.id,
                              game_type_id: data.game_type_id,
                              room_id: data.room_id)

        cache_game(game)
      end

      @message = "New game successfully created!"

      @success = true
    end

    def cache_game(game)
      recorder = Snapshots::Recorders::Game.new(game.id)
      recorder.game_type_data(game_type_data.game_data)

      team_entry = Snapshots::Entries::Team.new(id: team.id, name: team.name, user_id: team.user_id)
      recorder.team(team_entry)

      players.each do |player|
        player_entry = Snapshots::Entries::Player.new(id: player.id, team_id: player.team_id, name: player.name,
                                                      number: player.number, position: player.position,
                                                      sub_position: player.sub_position,
                                                      location: game_type_data.game_data["players"]["types"][player.sub_position]["game_start_position"],
                                                      stats: { offense: player.offense, defense: player.defense,
                                                               stamina: player.stamina, speed: player.speed,
                                                               morale: player.morale, health: player.health },
                                                      coordinates: { x: 0, y: 0 })
        recorder.player(player_entry)
      end
    end

    def players
      Player.where(team_id: team.id)
    end

    def team
      @team = begin
                query = TeamQueries::Show.new(initiator: initiator, data: { game_type_id: data.game_type_id })
                ::TeamQueryHandlers::Show.new(query).execute.message
              end
    end

    def game
      @game = begin
                query = GameQueries::ActiveGame.new(initiator: initiator, data: { game_type_id: data.game_type_id })
                ::GameQueryHandlers::ActiveGame.new(query).execute.message
              end
    end

    def game_type_data
      @game_type_data = begin
                          query = GameQueries::ShowType.new(initiator: initiator, data: { id: data.game_type_id })
                          ::GameQueryHandlers::ShowType.new(query).execute.message
                        end
    end
  end
end
