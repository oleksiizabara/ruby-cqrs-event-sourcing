module ChatEvents
  class NewMessage < ::BaseEvent
    attribute :type, Types::Coercible::String
    attribute :data do
      attribute :user_id, Types::Coercible::String
      attribute :text, Types::Coercible::String
      attribute :created_at, Types::Params::DateTime | Types::Params::Time
      attribute :room_id, Types::Coercible::String
    end
  end
end
