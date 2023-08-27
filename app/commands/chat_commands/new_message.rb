module ChatCommands
  class NewMessage < ::Command
    attribute :initiator, Types::Any
    attribute :data do
      attribute :room_id, Types::Coercible::Integer
      attribute :text, Types::String
      attribute :created_at, Types::Params::DateTime | Types::Params::Time
    end
  end
end
