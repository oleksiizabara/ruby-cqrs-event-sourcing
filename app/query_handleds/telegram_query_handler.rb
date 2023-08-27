class TelegramQueryHandler < QueryHandler
  def execute
    reset_active_chat_session

    perform_query

    set_reply if need_to_reply
    self
  end

  private

  include TelegramSession

  delegate :need_to_reply, to: :query
  delegate :chat, :update, :session, :params, to: :data

  def set_reply
    @message = {
      reply_markup: @message[:reply_markup],
      chat_id: chat['id'],
      message_id: chat_message["id"]
    }
  end
end