module TelegramCommandHandlers
  class NewRoom < ::TelegramCommandHandler
    private

    def handle
      if with_context
        create_room
      else
        @message = {
          text: 'Enter room name:',
          reply_markup: resized_keyboard(inline_keyboard: [[{ text: 'Back', callback_data: 'start_reply' }]])
        }
      end

      @success = true

    rescue ::RoomCommandHandlers::Create::InvalidRoomPramsError => e
      @message = {
        text: e.message,
        reply_markup: resized_keyboard(inline_keyboard: [[{ text: 'Menu', callback_data: 'start_reply' }]]) }
    end

    def create_room
      command = RoomCommands::Create.new(initiator: initiator, data: { name: callback_message })
      result = RoomCommandHandlers::Create.new(command).perform

      @message = {
        text: result.message,
        reply_markup: resized_keyboard(inline_keyboard: [[{ text: 'Back', callback_data: 'start_reply' }]])
      }
    end
  end
end
