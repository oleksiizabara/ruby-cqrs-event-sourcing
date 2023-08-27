module GameQueryHandlers
  class ListWaitingOpponent < ::QueryHandler
    private

    def perform_query
      @message = Game.where(status: Game::WAITING_FOR_OPPONENT)
                     .joins("LEFT JOIN game_types ON game_types.id = games.game_type_id")
                     .joins("LEFT JOIN teams AS home_team ON home_team.id = games.home_team_id")
                     .select("games.*, game_types.game_data AS game_data, home_team.name AS home_team_name")
                     .where(game_type_id: data.game_type_id, room_id: data.room_id)
    end
  end
end