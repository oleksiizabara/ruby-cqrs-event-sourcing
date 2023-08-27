module Snapshots
  module Entries
    class Team < Entry
      attribute :id, Types::Coercible::String, setter: false
      attribute :user_id, Types::Coercible::String, setter: false
      attribute :name, Types::Coercible::String
      attribute :score, Types::Coercible::Integer.default(0)
      attribute :home, Types::Params::Bool
      attribute :bot, Types::Params::Bool.default(false)
    end
  end
end
