module GameCommandHandlers
  class LeaveGame < ::CommandHandler

    private

    def handle
      Game.transaction do
        game.update!(status: Game::FINISHED, end_time: finished_at)

        event = GameEvents::GameFinished.new(type: "UserLeftGame", data: { game_id: game.id,
                                                                           finished_at: finished_at })

        EventStore::Store.publish('game', event)
      end

      def finished_at
        @finish_at ||= DateTime.now
      end

      def game
        @game ||= Game.find(data.game_id)
      end
    end
  end
end
