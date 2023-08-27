module GameCommandHandlers
  class SetStartingLineUp < ::CommandHandler
    private

    def handle
      player = snapshot_reader.player(team.id, data.player_id)
      player.on_field = data.on_field

      snapshot_recorder.player(player)

      @message = "Done!"

      @success = true
    end

    def snapshot_recorder
      ::Snapshots::Recorders::Game.new(game.id)
    end

    def snapshot_reader
      ::Snapshots::Readers::Game.new(game.id)
    end

    def team
      @team ||= Team.find_by(user_id: initiator.id, game_type_id: game.game_type_id)
    end

    def game
      @game ||= Game.find(data.game_id)
    end

    def players
      Player.find(data.player_id)
    end
  end
end
