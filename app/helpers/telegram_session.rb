module TelegramSession
  include ActiveSupport::Concern
  include  ActionView::Helpers::DateHelper

  def callback_message
    update.dig('message', 'text')
  end

  def telegram_user
    @telegram_user ||= chat_message['from']
  end

  def resized_keyboard(keyboard)
    keyboard.merge!(resize_keyboard: true,
                    one_time_keyboard: true,
                    selective: true)
  end

  def chat_message
    update['message'] || update['callback_query']
  end

  def ago(time)
    time_ago_in_words(time)
  end

  def refresh_active_chat_session
    session[:in_chat] = true
    session[:room_id] = params[:room_id]
    session[:chat_message_id] = (chat_message["message"] || chat_message)["message_id"]
  end

  def reset_active_chat_session
    session[:in_chat] = false
  end

  def delete_message
    Telegram.bot.delete_message(chat_id: chat["id"], message_id: chat_message["message_id"])
  end

  def document
    chat_message['document']
  end
end
