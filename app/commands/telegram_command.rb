class TelegramCommand < Command
  attribute :initiator, Types::Any
  attribute :with_context, Types::Bool.default(false)
  attribute :data do
    attribute :chat, Types::Hash
    attribute :update, Types::Hash
    attribute :session, Types::Any
    attribute :params, Types::Hash.default({})
  end
end