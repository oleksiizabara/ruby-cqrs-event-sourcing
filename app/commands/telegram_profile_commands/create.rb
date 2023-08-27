module TelegramProfileCommands
  class Create < ::Command
    attribute :data do
      attribute :telegram_id, Types::Coercible::String
      attribute :user, Types.Instance(::User)
      attribute :chat_id, Types::Coercible::String
      attribute :nickname, Types::Coercible::String
    end
  end
end
