module TelegramCommandHandlers
  class NewMessage < ::TelegramCommandHandler
    private

    def handle
      session[:in_chat] = true

      command = ChatCommands::NewMessage.new(initiator: initiator, data: { room_id: session[:room_id],
                                                                           text: callback_message,
                                                                           created_at: Time.now })

      result = ChatCommandHandlers::NewMessage.new(command).perform

      if result.success
        delete_message
        update_chat_message
      end

      @success = true
    end

    def delete_message
      Telegram.bot.delete_message(chat_id: chat["id"], message_id: chat_message["message_id"])
    end

    def update_chat_message
      query = ChatQueries::Messages.new(initiator: initiator, data: { room_id: session[:room_id] })
      messages = ChatQueryHandlers::Messages.new(query).execute.message

      Telegram.bot.edit_message_text(chat_id: chat['id'],
                                     message_id: session[:chat_message_id],
                                     text: messages.map { |message| "#{message.user} (#{ago(message.created_at)}): #{ message.text}" }.join("\n"),
                                     reply_markup: resized_keyboard(
                                       inline_keyboard: [[{ text: "Back", callback_data: "room:room_id=#{session[:room_id]}" },
                                                          { text: "Refresh Chat", callback_data: "refresh_chat:room_id=#{session[:room_id]}" }]]
                                     ),
                                     parse_mode: 'Markdown')
    end
  end
end
