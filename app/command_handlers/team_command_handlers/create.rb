module TeamCommandHandlers
  class Create < ::CommandHandler
    class InvalidTeamParams < ::CommandHandler::Error; end

    private

    def handle
      team = Team.new(user_id: initiator.id, game_type_id: data.game_type_id, name: data.name)
      team.save!

      @success = true
    rescue ActiveRecord::RecordInvalid => e
      raise InvalidTeamParams, e.message
    end
  end
end
