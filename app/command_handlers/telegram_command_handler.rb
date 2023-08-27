class TelegramCommandHandler < CommandHandler
  attr_reader :context

  def perform
    @context = nil

    reset_active_chat_session

    super
  end

  private

  include TelegramSession

  delegate :with_context, to: :command
  delegate :chat, :update, :session, :params, to: :data
end
