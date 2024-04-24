module TeamQueryHandlers
  class Show < ::QueryHandler
    private

    def perform_query
      @message = Team.select(:id, :name, :completed, "game_types.game_data AS game_team_data", :user_id,
                             :wins_count, :losses_count, :draws_count, :points_scored, :points_conceded, :game_type_id)
                     .joins(:game_type).where(user_id: initiator.id)

      @message = @message.where(id: data.id) if data.id.present?
      @message = @message.where(game_type_id: data.game_type_id) if data.game_type_id.present?

      @message = @message.first
    end
  end
end
