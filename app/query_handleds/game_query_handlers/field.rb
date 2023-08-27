module GameQueryHandlers
  class Field < ::QueryHandler
    private

    def perform_query
      @message = ActiveSupport::InheritableOptions.new(
        team: team,
        players: players,
        opponent: opponent,
        opponents: opponents,
        active_bonus: active_bonus,
        active_strategy: active_strategy,
        opponents_active_bonus: opponents_active_bonus,
        opponents_active_strategy: opponents_active_strategy,
        bonuses: bonuses,
        strategies: strategies,
        result: game_result,
        game_type_data: reader.game_type_data,
        events: reader.events
      )
    end

    def players
      @players ||= reader.players(team.id)
    end

    def opponents
      @opponents ||= reader.players(opponent.id)
    end

    def team
      @team ||= reader.team(initiator.id)
    end

    def teams
      @teams ||= reader.teams
    end

    def opponent
      @opponent ||= reader.opponent(initiator.id)
    end

    def active_bonus
      @active_bonus ||= reader.bonus(team.id)
    end

    def active_strategy
      @active_strategy ||= reader.strategy(team.id)
    end

    def opponents_active_bonus
      @opponents_active_bonus ||= reader.bonus(opponent.id)
    end

    def opponents_active_strategy
      @opponents_active_strategy ||= reader.strategy(opponent.id)
    end

    def bonuses
      @bonuses ||= bonuses_reader.all
    end

    def strategies
      @strategies ||= strategies_reader.all
    end

    def game_result
      result = ["#{team.name} #{team.score}", "#{opponent.name} #{opponent.score}"]
      result.reverse! if team.home

      result.join(' : ')
    end

    def bonuses_reader
      @bonuses_reader ||= Snapshots::Readers::Bonus.new('bonuses')
    end

    def strategies_reader
      @strategies_reader ||= Snapshots::Readers::Strategy.new('strategies')
    end

    def reader
      @reader ||= Snapshots::Readers::Game.new(data.game_id)
    end
  end
end
