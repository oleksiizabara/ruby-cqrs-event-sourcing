module TelegramProfileCommandHandlers
  class Create < ::CommandHandler
    private

    def handle
      TelegramProfile.create!(command.data.to_hash)

      @success = true
    end
  end
end
