module GameEventHandlers
  class GameFinished < ::EventHandler
    def handle
      Game.transaction do
        return unless game.status == ::Game::FINISHED

        ::Games::Finisher.new(game: game, finish_event: ::Games::Finisher::USER_LEFT).call!
      end
    end

    private

    def finish_event
      ::Games::Finisher::TIME_OVER
    end

    def game
      @game ||= Game.find(data.game_id)
    end
  end
end
