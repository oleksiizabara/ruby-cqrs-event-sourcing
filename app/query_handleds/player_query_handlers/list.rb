module PlayerQueryHandlers
  class List < ::QueryHandler
    def perform_query
      @message = Player.select("players.*, GREATEST(defense, offense) as max_stat")
                       .where(team_id: data.team_id)
    end
  end
end