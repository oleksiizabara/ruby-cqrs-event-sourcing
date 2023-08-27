module TelegramQueryHandlers
  class Chat < ::TelegramQueryHandler
    private

    def perform_query
      query = ChatQueries::Messages.new(initiator: initiator, data: { room_id: params[:room_id] })
      messages = ChatQueryHandlers::Messages.new(query).execute.message

      refresh_active_chat_session

      text = messages.map { |message| "#{message.user} (#{ago(message.created_at)}): #{ message.text}" }.join("\n")

      Telegram.bot.edit_message_text(chat_id: chat['id'],
                                     message_id: session[:chat_message_id],
                                     text: text.presence || "No messages yet. Post something...",
                                     reply_markup: resized_keyboard(
                                       inline_keyboard: [[{ text: "Back", callback_data: "room:room_id=#{session[:room_id]}" },
                                                          { text: "Refresh Chat", callback_data: "refresh_chat:room_id=#{session[:room_id]}" }]]
                                     ),
                                     parse_mode: 'Markdown')
    end
  end
end