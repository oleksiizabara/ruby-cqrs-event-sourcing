module GameQueryHandlers
  class ActiveGame < ::QueryHandler
    private

    def perform_query
      games = Game.where(home_user_id: initiator.id).or(Game.where(guest_user_id: initiator.id))
                  .where(status: [:pending, :owner_ready, :waiting_for_opponent, :waiting_for_opponent_line_up,
                                  :in_progress, :finished])

      games = games.where(game_type_id: data.game_type_id) if data.game_type_id.present?
      games = games.where(id: data.id) if data.id.present?

      @message = games.last
    end
  end
end
