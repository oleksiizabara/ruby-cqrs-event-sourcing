module GameCommandHandlers
  class SaveLineUp < ::CommandHandler
    class ValidationError < ::StandardError; end
    private

    def handle
      validate

      case game.status
      when Game::PENDING
        new_status = Game::OWNER_READY
      when Game::WAITING_FOR_OPPONENT_LINE_UP
        publish_game_started_event

        new_status = Game::IN_PROGRESS
      else
        return
      end

      game.status = new_status
      game.save!

      @success = true
    end

    def validate

    end

    def publish_game_started_event
      event = GameEvents::GameStarted.new(type: "GameStarted", data: { game_id: game.id, started_at: Time.now })

      EventStore::Store.publish("game", event)
    end

    def game
      @game ||= Game.find(data.game_id)
    end
  end
end
