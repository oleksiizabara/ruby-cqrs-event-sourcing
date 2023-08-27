module GameCommandHandlers
  class JoinGame < ::CommandHandler
    class DontHaveTeamError < ::CommandHandler::Error; end
    class UncompletedTeamError < ::CommandHandler::Error; end
    class ActiveGameError < ::CommandHandler::Error; end

    private

    def handle
      Game.transaction do
        raise DontHaveTeamError if team.nil?
        raise UncompletedTeamError unless team.completed?
        raise ActiveGameError if game.guest_team_id.present?

        game.guest_team_id = team.id
        game.guest_user_id = initiator.id

        cache_guest_team

        game.status = Game::WAITING_FOR_OPPONENT_LINE_UP
        game.save!
      end

      @message = "You have successfully joined the game!"

      @success = true
    end

    def cache_guest_team
      recorder = Snapshots::Recorders::Game.new(game.id)

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
      @team ||= begin
                  query = TeamQueries::Show.new(initiator: initiator, data: { game_type_id: game.game_type_id })
                  ::TeamQueryHandlers::Show.new(query).execute.message
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
