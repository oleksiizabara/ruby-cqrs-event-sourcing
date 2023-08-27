module TelegramCommandHandlers
  class CreateGame < ::TelegramCommandHandler
    private

    def handle
      if document.present?
        command = GameCommands::Create.new(initiator: initiator, data: { json: parsed_document_json })
        GameCommandHandlers::Create.new(command).perform

        @message = {
          text: "Game has been created",
          reply_markup: resized_keyboard(inline_keyboard: [[{ text: 'Back', callback_data: "game_types:room_id=#{params[:room_id]}" }] ]),
          parse_mode: 'Markdown'
        }
      else
        @message = {
          text: "OK! let's create the game! Send me the JSON file with the game data",
          reply_markup: {
            inline_keyboard: [[ { text: "Get JSON example", callback_data: "game_json_example:room_id=#{params[:room_id]}" } ]],
            resize_keyboard: true,
            one_time_keyboard: true,
            selective: true
          }
        }
      end

      @success = true

    rescue ::GameCommandHandlers::Create::InvalidGameParamsError => e
      @message = {
        text: e.message,
        reply_markup: resized_keyboard(inline_keyboard: [[{ text: 'Back', callback_data: "game_types:room_id=#{params[:room_id]}" }]])
      }

      @success = true
    end

    def parsed_document_json
      file_id = document['file_id']

      file_path = Telegram.bot.get_file(file_id: file_id).dig('result', 'file_path')
      url = "https://api.telegram.org/file/bot#{Telegram.bot.token}/#{file_path}"

      response = HTTParty.get(url)

      response.body
    end
  end
end
