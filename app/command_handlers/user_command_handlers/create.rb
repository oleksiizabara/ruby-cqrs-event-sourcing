module UserCommandHandlers
  class Create < ::CommandHandler
    private

    def handle
      user = User.new(command.data.to_h)
      user.save!

      @success = true
    rescue ActiveRecord::RecordInvalid => e
      @error = e.message
    end
  end
end
