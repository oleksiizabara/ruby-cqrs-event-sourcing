module Snapshots
  module Entries
    class Message < Entry
      attribute :user, Types::Coercible::String
      attribute :text, Types::Coercible::String
      attribute :created_at, Types::Params::DateTime | Types::Params::Time
    end
  end
end
