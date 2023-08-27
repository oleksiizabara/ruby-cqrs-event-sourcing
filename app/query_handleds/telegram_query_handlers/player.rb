module TelegramQueryHandlers
  class Player < ::TelegramQueryHandler
    private

    def perform_query
      query = ::PlayerQueries::Show.new(initiator: initiator, data: { id: params[:id] })
      player = ::PlayerQueryHandlers::Show.new(query).execute.message

      @message = {
        text: "#{player.sub_position.humanize }: #{player.name}\n\n" \
              "⚔️_Offense: #{player.offense}_\n" \
              "🛡_Defense: #{player.defense}_\n" \
              "🟢_Stamina: #{player.stamina}_\n" \
              "🏃_Speed: #{player.speed}_\n",
        reply_markup: resized_keyboard(inline_keyboard: [[{ text: 'Back',
                                                            callback_data: "team:room_id=#{params[:room_id]}&team_id=#{params[:team_id]}" }]]),
        parse_mode: 'Markdown'
      }
    end
  end
end
