module TeamCommandHandlers
  class AddPlayer < ::CommandHandler
    private

    def handle
      team = Team.find(command.team_id)
      player = Player.find(command.player_id)
      team.add_player(player)
      team.save!

      @success = true
    rescue Team::InvalidPlayer => e
      @errors << e.message
    end
  end
end
