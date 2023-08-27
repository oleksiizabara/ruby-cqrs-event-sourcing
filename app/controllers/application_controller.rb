class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound do
    { errors: 'Please log in to continue', success: false }
  end
  
  def query
    query = "#{entry}Queries::#{query_identifier}".constantize.new(**game_params)
    result = "#{entry}QueryHandlers::#{query_identifier}".constantize.new(query).perform

    { success: true, data: result.message }
  end

  def command
    command = "#{entry}Commands::#{command_identifier}".constantize.new(**game_params)
    result = "#{entry}CommandHandlers::#{command_identifier}".constantize.new(command).perform

    result.success? ? { success: true } : { errors: result.errors, success: false }
  end
  
  private

  def command_identifier
    params[:command_identifier].camelize
  end

  def query_identifier
    params[:query_identifier].camelize
  end
  
  def entry
    self.class.name.split('Controller').first
  end

  def game_params
    { data: params.permit(data: {})[:data], initiator: current_user }
  end

  def current_user
    return if command_identifier == ::User::Commands::Create.name

    @current_user ||= AccessToken.valid.find_by!(token: params[:token]).user
  end
end
