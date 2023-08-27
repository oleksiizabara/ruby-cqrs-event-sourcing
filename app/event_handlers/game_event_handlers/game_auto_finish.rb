module GameEventHandlers
  class GameAutoFinish < ::EventHandler
    def handle
      return if finished?

      sleep(finish_at - game.start_time)

      return if finished?

      event = GameEvents::GameFinished.new(type: "GameFinished", data: { game_id: game.id,
                                                                         finished_at: finish_at })

      EventStore::Store.publish('game', event)
    end

    def finish_at
      game.start_time + duration
    end

    def finished?
      Game.transaction do
        game.status.in?([Game::FINISHED, Game::SUMMARIZED, Game::CANCELED])
      end
    end

    def duration
      @duration ||= ::Snapshots::Readers::Game.new(game.id).game_type_data["periods"].sum do |period|
        period["duration"].to_i * 60
      end
    end

    def game
      @game ||= Game.find(data.game_id)
    end
  end
end
