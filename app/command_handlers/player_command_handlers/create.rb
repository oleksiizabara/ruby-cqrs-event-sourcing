module PlayerCommandHandlers
  class Create < ::CommandHandler
    private

    def handle
      Players::Creator.new(team_id: data.team_id,
                           position: data.position,
                           number: data.number,
                           sub_position: data.sub_position,
                           name: data.name,
                           game_type_id: data.game_type_id).call!

      @success = true
    end
  end
end
