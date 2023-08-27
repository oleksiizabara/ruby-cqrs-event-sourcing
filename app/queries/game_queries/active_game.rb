module GameQueries
  class ActiveGame < ::Query
    attribute :initiator, Types::Any
    attribute :data do
      attribute :id, Types::Coercible::String.default(nil)
      attribute :game_type_id, Types::Coercible::String.default(nil)
    end
  end
end
