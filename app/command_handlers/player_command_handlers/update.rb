module PlayerCommandHandlers
  class Update < ::CommandHandler
    private

    def handle
      player = Player.find(command.player_id)
      player.name = command.name
      player.save!

      @success = true
    rescue ActiveRecord::RecordInvalid => e
      @errors << e.message
    end
  end
end
