Rails.application.routes.draw do
  telegram_webhook TelegramWebhooksController

  namespaces = %w[teams users games players rooms]

  namespaces.each do |namespace|
    namespace namespace do
      post 'command/:command_identifier', to: "#{namespace}#command"
      get 'query/:query_identifier', to: "#{namespace}#query"
    end
  end

  namespace :sessions do
    post 'create'
    delete 'destroy'
  end
end
