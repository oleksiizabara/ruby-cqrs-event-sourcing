module TelegramCommandHandlers
  class Register < ::TelegramCommandHandler
    private

    def handle
      if with_context
        session[:user_email] = callback_message

        @message = {
          text: "OK! let's protect your account!",
          reply_markup: {
            inline_keyboard: [[ { text: "Set Password", callback_data: 'set_password' } ]],
            resize_keyboard: true,
            one_time_keyboard: true,
            selective: true
          }
        }
      else
        @message = { text: "Enter your email:" }
      end

      @success = true
    end
  end
end
