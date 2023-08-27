module TeamQueryHandlers
  class List < ::QueryHandler
    private

    def perform_query
      @message = Team.select(:id, :name, :completed, "game_types.game_data AS game_team_data",
                             "game_types.id AS game_type_id",
                             :wins_count, :losses_count, :draws_count,
                             :points_scored, :points_conceded)
                     .joins(:game_type).where(user_id: initiator.id)

      @message = @message.where(game_type_id: data.game_type_id) if data.game_type_id.present?

      @message = @message.order(:name)
    end
  end
end
