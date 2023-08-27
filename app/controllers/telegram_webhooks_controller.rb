class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  WEBHOOKS_QUERIES = %w[start rooms chat room game_types game_type team teams game player active_game
                        waiting_games_list game_field].freeze
  WEBHOOKS_COMMANDS = %w[register set_password new_room join_room leave_room new_message refresh_chat
                         create_game create_team start_game leave_game create_player set_starting_line_up
                         save_line_up set_opponent_type join_game].freeze

  def self.define_routes
    WEBHOOKS_QUERIES.each do |query_name|
      [query_name, "#{query_name}_reply"].each do |method_name|
        define_method "#{method_name}!" do |params: {}|
          message_context_session.delete(:context)

          query_name = method_name.split('_reply').first
          need_to_reply = method_name.include?('_reply')

          query = "TelegramQueries::#{query_name.camelize}".constantize.new(game_params(params).merge!(need_to_reply: need_to_reply))
          result = "TelegramQueryHandlers::#{query_name.camelize}".constantize.new(query).execute

          return if result.message.blank?

          if need_to_reply
            edit_message :reply_markup, result.message
          else
            respond_with :message, result.message
          end
        end
      end
    end

    WEBHOOKS_COMMANDS.each do |command_name|
      [command_name, "#{command_name}_reply"].each do |method_name|
        define_method "#{method_name}!" do |data = nil, *, params: {}|
          command_name = method_name.split('_reply').first
          need_to_reply = method_name.include?('_reply')

          command = "TelegramCommands::#{command_name.camelize}".constantize.new(game_command_params(params, data))
          result = "TelegramCommandHandlers::#{command_name.camelize}".constantize.new(command).perform

          save_context(result.context || "#{command_name}!") if result.success && data.nil?

          return if result.message.blank?

          if need_to_reply
            edit_message :reply_markup, result.message
          else
            respond_with :message, result.message
          end
        end
      end
    end
  end

  define_routes

  def callback_query(data)
    name, webhook_params = parse_callback_data(data)

    if WEBHOOKS_COMMANDS.map { |query| [query, "#{query}_reply"] }.flatten.include?(name)
      send("#{name}!", nil, params: webhook_params)
    elsif WEBHOOKS_QUERIES.map { |query| [query, "#{query}_reply"] }.flatten.include?(name)
      send("#{name}!", params: webhook_params)
    else
      answer_callback_query t('.no_alert')
    end
  end

  def message(_message)
    if session[:in_chat]
      command = TelegramCommands::NewMessage.new(game_command_params({ room_id: session[:room_id] }, "new_message"))
      TelegramCommandHandlers::NewMessage.new(command).perform
      nil
    else
      respond_with :message, text: "Hey! I'm not a ChatGPT bot! I don't understand you!"
    end
  end

  private

  include TelegramSession

  def parse_callback_data(data)
    name, webhook_params = data.split(':')

    [name, webhook_query_params(webhook_params)]
  end

  def webhook_query_params(webhook_params)
    webhook_params.to_s.split('&').each_with_object({}) do |param, hash|
      key, value = param.split('=')
      hash[key.to_sym] = value
    end
  end

  def game_command_params(params, command = nil)
    game_params(params).merge!(with_context: command.present?)
  end

  def game_params(params)
    { data: { chat: chat, update: update, session: session, params: params }, initiator: current_user }
  end

  def current_user
    @current_user ||= if session[:user_email].present?
                        query = ::UserQueries::UserByEmail.new(data: { email: session[:user_email] })
                        ::UserQueryHandlers::UserByEmail.new(query).execute.message
                      else
                        TelegramProfile.find_by(telegram_id: from['id'])&.user
                      end
  end
end
