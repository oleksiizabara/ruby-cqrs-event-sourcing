module TelegramCommandHandlers
  class SetPassword < ::TelegramCommandHandler
    private

    def handle
      if with_context
        result = UserCommandHandlers::Create.new(user_create_command).perform

        return @message = { text: result.error } unless result.success

        publish_event

        @message = {
          text: "Great! Now we can play!",
          reply_markup: resized_keyboard(inline_keyboard: [[ { text: "Rooms", callback_data: 'rooms' },
                                                             { text: "New Room", callback_data: 'new_room' } ]])
        }
      else
        @message = { text: "Enter your password:" }
      end

      @success = true
    end

    def publish_event
      event = TelegramProfileEvents::Create.new(type: 'Create', data: { telegram_id: telegram_user['id'],
                                                                        user_email: session[:user_email],
                                                                        chat_id: chat['id'],
                                                                        nickname: telegram_user['username'] })

      ::EventStore::Store.publish('telegram_profile', event)
    end



    def user_create_command
      @user_create_command ||= UserCommands::Create.new(data: { email: session[:user_email],
                                                                password: callback_message,
                                                                nickname: telegram_user['first_name'] },
                                                        initiator: initiator)
    end
  end
end
