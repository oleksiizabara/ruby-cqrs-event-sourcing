class TelegramQuery < Query
  attribute :initiator, Types::Any
  attribute :need_to_reply, Types::Bool.default(false)
  attribute :data do
    attribute :chat, Types::Hash
    attribute :update, Types::Hash
    attribute :session, Types::Any
    attribute :params, Types::Hash
  end
end
