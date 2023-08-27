module GameQueries
  class ListWaitingOpponent < ::Query
    attribute :initiator, Types::Any
    attribute :data do
      attribute :room_id, Types::Coercible::String
      attribute :game_type_id, Types::Coercible::String
    end
  end
end