module TelegramProfileEventHandlers
  class Create < ::EventHandler
    def handle
      if user
        command = TelegramProfileCommands::Create.new(data: { telegram_id: event.data.telegram_id,
                                                              user: user,
                                                              chat_id: event.data.chat_id,
                                                              nickname: event.data.nickname })

        TelegramProfileCommandHandlers::Create.new(command).perform

        @success = true
      end
    end

    private

    def user
      @user ||= ::UserQueryHandlers::UserByEmail.new(user_query).execute.message
    end

    def user_query
      @user_query ||= UserQueries::UserByEmail.new(data: { email: event.data.user_email })
    end
  end
end
