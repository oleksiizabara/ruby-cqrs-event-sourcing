module TelegramQueryHandlers
  class Start < ::TelegramQueryHandler
    private

    def perform_query
      update_or_initiate_session
      set_instructions
    end

    def update_or_initiate_session
      session[:active] = true unless session[:active]
    end

    def set_instructions
      @message = initiator.present? ? menu_message : welcome_message
    end

    def menu_message
      {
        text: "*Hi again, #{telegram_user['first_name']}!* What would you like to do?",
        parse_mode: 'Markdown',
        reply_markup: resized_keyboard(inline_keyboard: [[ { text: "Rooms", callback_data: "rooms_reply" },
                                                           { text: "Create Room", callback_data: "new_room" } ]])
      }
    end

    def welcome_message
      {
        text: "*Hi again, #{telegram_user['first_name']}!* You are new. I can help you to sign up:",
        parse_mode: "Markdown",
        reply_markup: resized_keyboard(inline_keyboard: [[ { text: 'Sign Up', callback_data: "register" } ]])
      }
    end
  end
end
