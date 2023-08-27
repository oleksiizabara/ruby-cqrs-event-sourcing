module GameEventHandlers
  class GameStarted < ::EventHandler
    def handle
      Game.transaction do
        game.update!(start_time: data.started_at)
        publish_auto_finish_event
      end
    end

    private

    def publish_auto_finish_event
      event = GameEvents::GameAutoFinish.new(type: "GameAutoFinish", data: { game_id: game.id })

      EventStore::Store.publish("game", event)
    end

    def game
      @game ||= Game.find(data.game_id)
    end
  end
end
