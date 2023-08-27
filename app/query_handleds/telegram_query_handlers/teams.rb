module TelegramQueryHandlers
  class Teams < ::TelegramQueryHandler
    private

    def perform_query
      query = ::TeamQueries::List.new(initiator: initiator, data: { game_type_id: params[:game_type_id] })

      teams = ::TeamQueryHandlers::List.new(query).execute.message.map do |team|
        [{ text: "#{team.game_team_data["assets"]["emoji"]}  #{team.name}",
           callback_data: "team:room_id=#{params[:room_id]}&team_id=#{team.id}&game_type_id=#{team.game_type_id}" }]
      end

      @message = {
        text: "Choose team",
        reply_markup: resized_keyboard(inline_keyboard: teams),
        parse_mode: 'Markdown'
      }
    end
  end
end
