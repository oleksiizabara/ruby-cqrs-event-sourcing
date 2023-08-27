module Snapshots
  module Entries
    class GameEvent < Entry
      attribute :type, Types::Coercible::String
      attribute :text, Types::Coercible::String
      attribute :team_id, Types::Coercible::String.default(nil)
      attribute :player_id, Types::Coercible::String.default(nil)
      attribute :created_at, Types::Params::DateTime | Types::Params::Time
    end
  end
end
