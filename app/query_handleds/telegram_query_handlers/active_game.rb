module TelegramQueryHandlers
  class ActiveGame < ::TelegramQueryHandler
    private

    def perform_query
      case game.status
      when Game::PENDING
        handle_pending_game
      when Game::OWNER_READY
        handle_owner_ready_game
      when Game::WAITING_FOR_OPPONENT
        handle_waiting_for_opponent_game
      when Game::WAITING_FOR_OPPONENT_LINE_UP
        handle_waiting_for_opponent_line_up_game
      when Game::IN_PROGRESS
        handle_in_progress_game
      when Game::FINISHED
        handle_finished_game
      end
    end

    def handle_pending_game
      @message = {
        text: "Let's continue",
        reply_markup: resized_keyboard(inline_keyboard: [[{ text: "Choose Starting Line-up ", callback_data: "set_starting_line_up:game_id=#{game.id}" }],
                                                         [{ text: "Cancel", callback_data: "cancel_game:id=#{game.id}" }]]),
        parse_mode: 'Markdown'
      }
    end

    def handle_owner_ready_game
      @message = {
        text: "Play with:",
        reply_markup: resized_keyboard(inline_keyboard: [[{ text: "🤖 Bot", callback_data: "set_opponent_type:game_id=#{params[:game_id]}&type=bot" },
                                                          { text: "👤 Player", callback_data: "set_opponent_type:game_id=#{params[:game_id]}&type=player" }],
                                                         [{ text: "Cancel", callback_data: "cancel_game:id=#{game.id}" }]]),
        parse_mode: 'Markdown'
      }
    end

    def handle_waiting_for_opponent_game
      buttons = []
      if owner?
        buttons << { text: "Refresh", callback_data: "active_game:id=#{game.id}" }
        buttons << { text: "Cancel", callback_data: "cancel_game:id=#{game.id}" }
      end

      @message = {
        text: "Waiting for opponent\n\n🤔 _#{game_tips.sample}_",
        reply_markup: resized_keyboard(inline_keyboard: [buttons]),
        parse_mode: 'Markdown'
      }
    end

    def handle_waiting_for_opponent_line_up_game
      buttons = []
      if owner?
        text = "Waiting for guest team line-up\n\n🤔 _#{game_tips.sample}_"
        buttons << { text: "Refresh", callback_data: "active_game:id=#{game.id}" }
      else
        text = "Waiting for home team line-up"
        buttons << { text: "Choose starting line-up", callback_data: "set_starting_line_up:game_id=#{game.id}" }
      end

      @message = {
        text: text,
        reply_markup: resized_keyboard(inline_keyboard: [buttons,
                                                         [{ text: "Leave Game", callback_data: "leave_game:id=#{game.id}" }]]),
        parse_mode: 'Markdown'

      }
    end

    def handle_in_progress_game
      @message = {
        text: "Game in progress",
        reply_markup: resized_keyboard(inline_keyboard: [[{ text: "Play", callback_data: "game_field:id=#{game.id}" }],
                                                         [{ text: "Leave Game", callback_data: "leave_game:id=#{game.id}" }]]),
        parse_mode: 'Markdown'
      }
    end

    def handle_finished_game
      @message = {
        text: "Game finished. \n #{game.home_team_score} - #{game.guest_team_score}.",
        reply_markup: resized_keyboard(inline_keyboard: [[{ text: "📜 Game Details", callback_data: "game_details:id=#{game.id}" }],
                                                          [{ text: "Back", callback_data: "games" }]]),
        parse_mode: 'Markdown'
      }
    end

    def game
      @game ||= begin
                  query = ::GameQueries::ActiveGame.new(initiator: initiator, data: { game_type_id: params[:game_type_id],
                                                                                      id: params[:game_id] })
                  ::GameQueryHandlers::ActiveGame.new(query).execute.message
                end
    end

    def owner?
      game.home_user_id == initiator.id
    end

    def team
      @team ||= begin
                  query = ::TeamQueries::Show.new(initiator: initiator, data: { id: params[:id],
                                                                                game_type_id: params[:game_type_id] })
                  ::TeamQueryHandlers::Show.new(query).execute.message
                end
    end

    def game_tips
      [
        "Keep an eye on player performance: Player statistics can change throughout the game, so it's important to keep track of how your players are doing and make changes accordingly. Look at things like goals, assists, saves, and clean sheets to determine which players are performing well.",
        "Pay attention to the weather: The weather can have a big impact on how the game is played. For example, wet conditions can make the ball slippery and affect passing and shooting accuracy. Be sure to check the weather forecast before making your team selections.",
        "Use your bonuses wisely: Bonuses can be a powerful tool in your arsenal, but they should be used strategically. For example, you may want to use a bonus to boost the performance of one of your star players, or to sabotage the performance of a key player on the opposing team.",
        "Be flexible with your strategy: Sometimes, things don't go according to plan. If you see that your current strategy isn't working, don't be afraid to make changes. For example, if your team is struggling to score",
        "Take a balanced approach: It's important to have a balanced team with players who can perform well in different situations. For example, you may want to have a mix of players who are good at attacking and defending, or players who are good at passing and shooting.",
        "Don't forget about the bench: It's easy to focus on your starting line-up, but don't forget about the players on your bench. They can be just as important as your starters, so make sure you have a strong bench with players who can come in and make an impact.",
        "Don't be afraid to take risks: Sometimes, you have to take risks in order to win. For example, if your team is losing and you need a goal, don't be afraid to bring on an attacking player and go all out for the win.",
        "Keep an eye on the opposition: It's important to know your opponent's strengths and weaknesses. For example, if you know that your opponent has a strong defence, you may want to focus on attacking and try to score as many goals as possible.",
        "Don't forget about the referee: The referee can have a big impact on the game, so it's important to keep an eye on them. For example, if the referee is giving out a lot of yellow cards, you may want to play more defensively and avoid getting booked yourself.",
        "Don't forget about the fans: The fans can have a big impact on the game, so it's important to keep them happy. For example, if the fans are booing your team, you may want to change your tactics and try to win them over.",
        "Don't forget about the weather: The weather can have a big impact on the game, so it's important to keep an eye on the forecast. For example, if it's raining, you may want to play more defensively and avoid getting booked yourself."
      ]
    end
  end
end
