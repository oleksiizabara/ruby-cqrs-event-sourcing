module Games
  class Engine
    extend Dry::Initializer

    option :game, Types.Instance(Game)
    option :offence_team , Types.Instance(Team)
    option :defence_team, Types.Instance(Team)
    option :params, Types::Hash do
      option :strategy, Types.Instance(Strategy)
      option :bonuses, Types::Array.of(Types.Instance(Bonus)), default: proc { [] }
    end

    # each team has 7 active players
    # each player has a score: defence, offence, health, morale, stamina
    # each strategy can increase or decrease the score of the player
    # each bonus can increase or decrease the score of the player
    # each call can and one point to team score depending on which team has bigger score at the end of the call
    # each call can decrease the health, morale and stamina of the player depending on the strategy and bonus
    # each call can increase morale of the player if the team won the call
    # team will win the call if the score of all players is bigger than the score of the other team with random factor
    # team will lose the call if the score of all players is smaller than the score of the other team with random factor
    # team will draw the call if the score of all players is equal to the score of the other team with random factor
    def call
      offence_team_players = offence_team.players
      defence_team_players = defence_team.players

      offence_team_players.each do |player|
        player.score = player.score + params.strategy.offence_score + params.bonuses.sum(&:offence_score)
        player.score = player.score - params.strategy.defence_score - params.bonuses.sum(&:defence_score)
        player.score = player.score - params.strategy.health_score - params.bonuses.sum(&:health_score)
        player.score = player.score - params.strategy.morale_score - params.bonuses.sum(&:morale_score)
        player.score = player.score - params.strategy.stamina_score - params.bonuses.sum(&:stamina_score)
      end

      defence_team_players.each do |player|
        player.score = player.score + params.strategy.defence_score + params.bonuses.sum(&:defence_score)
        player.score = player.score - params.strategy.offence_score - params.bonuses.sum(&:offence_score)
        player.score = player.score - params.strategy.health_score - params.bonuses.sum(&:health_score)
        player.score = player.score - params.strategy.morale_score - params.bonuses.sum(&:morale_score)
        player.score = player.score - params.strategy.stamina_score - params.bonuses.sum(&:stamina_score)
      end

      offence_team_score = offence_team_players.sum(&:score)
      defence_team_score = defence_team_players.sum(&:score)

      offence_team_players.each do |player|
        player.health = player.health - params.strategy.health_score - params.bonuses.sum(&:health_score)
        player.morale = player.morale - params.strategy.morale_score - params.bonuses.sum(&:morale_score)
        player.stamina = player.stamina - params.strategy.stamina_score - params.bonuses.sum(&:stamina_score)
      end

      defence_team_players.each do |player|
        player.health = player.health - params.strategy.health_score - params.bonuses.sum(&:health_score)
        player.morale = player.morale - params.strategy.morale_score - params.bonuses.sum(&:morale_score)
        player.stamina = player.stamina - params.strategy.stamina_score - params.bonuses.sum(&:stamina_score)
      end

      if offence_team_score > defence_team_score
        offence_team_players.each do |player|
          player.morale = player.morale + params.strategy.more_morale_score + params.bonuses.sum(&:more_morale_score)
        end
      elsif offence_team_score < defence_team_score
        defence_team_players.each do |player|
          player.morale = player.morale + params.strategy.more_morale_score + params.bonuses.sum(&:more_morale_score)
        end
      end


    end
  end
end

