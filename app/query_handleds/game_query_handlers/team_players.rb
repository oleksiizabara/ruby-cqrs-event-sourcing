module GameQueryHandlers
  class TeamPlayers < ::QueryHandler
    private

    def perform_query
      @message = snapshot_reader.players(team.id)
    end

    def snapshot_reader
      ::Snapshots::Readers::Game.new(data.game_id)
    end

    def team
      @team ||= Team.find_by(user_id: initiator.id, game_type_id: game.game_type_id)
    end

    def game
      @game ||= Game.find(data.game_id)
    end
  end
end
