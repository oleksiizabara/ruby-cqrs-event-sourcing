module GameCommandHandlers
  class Create < ::CommandHandler
    class InvalidGameParamsError < ::CommandHandler::Error; end

    private

    def handle
      parsed_json = (data.json.is_a?(Hash) ? data.json : JSON.parse(data.json)).deep_symbolize_keys

      # TODO: validate json, approve game type in Admin panel
      begin
        GameType.transaction do
          game_type = GameType.create!(identifier: parsed_json[:identifier],
                                       game_data: parsed_json,
                                       approved: true,
                                       user_id: initiator.id)
          create_bot_team(game_type)
        end
      rescue StandardError => e
        Rails.logger.error(e.message)
        raise InvalidGameParamsError, e.message
      end

      @success = true
    end

    def bot
      @bot ||= Bot.first
    end

    def create_bot_team(game_type)
      team = Team.new(user_id: bot.id, game_type_id: game_type.id, name: bot_team_name)
      team.save!

      create_bot_players(team, game_type)
    end

    def bot_team_name
      adjectives = %w[Swift Mighty Fierce Savage Rapid Brave Majestic Thundering Golden Vicious]
      nouns = %w[Tigers Lions Hawks Eagles Wolves Dragons Bears Panthers Jaguars Cougars]

      "#{adjectives.sample} #{nouns.sample}"
    end

    def create_bot_players(team, game_type)
      game_type_data = game_type.game_data

      game_type_data["players"]["types"].each do |sub_positions, info|
        info["max_count"].times do
          create_bot_player(team, game_type, info["type"], sub_positions)
        end
      end
    end

    def create_bot_player(team, game_type, position, sub_position)
      command = PlayerCommands::Create.new(initiator: bot,
                                           data: {
                                             name: bot_player_name,
                                             number: bot_player_number,
                                             team_id: team.id,
                                             position: position,
                                             sub_position: sub_position,
                                             game_type_id: game_type.id
                                           })

      PlayerCommandHandlers::Create.new(command).perform
    end

    def bot_player_name
      first_names = %w[Avery Bailey Charlie Dylan Elliot Frankie Gus Harley Indiana Jordan Kai Logan Morgan Nicky Ollie Parker Quinn Reese Sage Terry Vesper Wylie Xander Yael Zenon]
      last_names = %w[Adams Baker Clark Davis Evans Franklin Garcia Hill Irwin Jones Kennedy Lee Meyer Nguyen Owens Patel Quinn Reynolds Smith Taylor Upton Valdez Williams Xu Young Zhang]

      first_names.sample + " " + last_names.sample
    end

    def bot_player_number
      number = numbers.sample

      numbers.delete(number)
    end

    def numbers
      @numbers ||= (1..99).to_a
    end
  end
end
