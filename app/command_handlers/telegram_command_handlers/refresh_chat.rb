module TelegramCommandHandlers
  class RefreshChat < ::TelegramCommandHandler
    private

    def handle
      refresh_active_chat_session

      update_chat_message

      @context = "new_message!"
      @success = true
    end

    def update_chat_message
      query = ChatQueries::Messages.new(initiator: initiator, data: { room_id: params[:room_id] })
      messages = ChatQueryHandlers::Messages.new(query).execute.message

      text = messages.map { |message| "#{message.user} (#{ago(message.created_at)}): #{ message.text}" }.join("\n")

      user_message =  chat_message["message"] || chat_message

      return if text.blank? || text == user_message["text"]

      Telegram.bot.edit_message_text(chat_id: chat['id'],
                                     message_id: user_message["message_id"],
                                     text: text.presence || "No messages yet... Post something...",
                                     reply_markup: resized_keyboard(
                                       inline_keyboard: [[{ text: "Back", callback_data: "room:room_id=#{params[:room_id]}" },
                                                          { text: "Refresh Chat", callback_data: "refresh_chat:room_id=#{params[:room_id]}" }]]
                                     ),
                                     parse_mode: 'Markdown')
    end
  end
end
