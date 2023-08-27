module TeamCommandHandlers
  class Update < ::CommandHandler
    private

    def handle
      team = Team.find(command.team_id)
      team.name = command.name
      team.save!

      @success = true
    rescue ActiveRecord::RecordInvalid => e
      @errors << e.message
    end
  end
end
