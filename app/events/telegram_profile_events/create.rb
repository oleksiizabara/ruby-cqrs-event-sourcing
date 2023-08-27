module TelegramProfileEvents
  class Create < ::BaseEvent
    attribute :type, Types::Coercible::String
    attribute :data do
      attribute :telegram_id, Types::Coercible::String
      attribute :user_email, Types::Coercible::String
      attribute :chat_id, Types::Coercible::String
      attribute :nickname, Types::Coercible::String
    end
  end
end