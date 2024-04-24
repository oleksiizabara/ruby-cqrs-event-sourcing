module Games
  class Finisher
    extend Dry::Initializer

    TIME_OVER = 'time_over'.freeze
    USER_LEFT = 'user_left'.freeze

    option :game
    option :finish_event, default: proc { TIME_OVER }

    def call!
      build_game_recap
      recalculate_players_stats(game.home_team_id)
      recalculate_players_stats(game.guest_team_id)
      recalculate_users_experience

      game.update!(status: Game::SUMMARIZED)
    end

    private

    def build_game_recap
      Games::RecapBuilder.new(game: game).call!
    end

    def recalculate_players_stats(team_id)
      snapshot_reader.players(team_id) do |player|
        Games::StatsRecalculator.new(game: game, player: player).call!
      end
    end

    def recalculate_users_experience
      Games::ExperienceRecalculator.new(user_id: game.home_user_id, game: game).call!
      Games::ExperienceRecalculator.new(user_id: game.guest_user_id, game: game).call!
    end

    def snapshot_reader
      ::Snapshots::Readers::Game.new(game.id)
    end
  end
end

