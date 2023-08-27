module GameEventHandlers
  class GameFinished < ::EventHandler
    def handle
      Game.transaction do
        return if game.status.in?(Game::FINISHED, Game::SUMMARIZED, Game::CANCELED)

        game.update!(status: Game::FINISHED, end_time: data.finished_at)
      end

      build_game_recap
      recalculate_players_stats
      recalculate_users_experience

      game.update!(status: Game::SUMMARIZED)
    end

    private

    def build_game_recap
      Games::RecapBuilder.new(game: game).call!
    end

    def recalculate_players_stats
      game.players.each do |player|
        Games::StatsRecalculator.new(player: player, game: game).call!
      end
    end

    def recalculate_users_experience
      game.players.each do |player|
        Games::ExperienceRecalculator.new(user_id: game.home_user_id, game: game).call!
        Games::ExperienceRecalculator.new(user_id: game.guest_user_id, game: game).call!
      end
    end

    def game
      @game ||= Game.find(data.game_id)
    end
  end
end
