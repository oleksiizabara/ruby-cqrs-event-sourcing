module GameQueries
  class ListTypes < ::Query
    attribute :initiator, Types::Any
    attribute :data do
      attribute :room_id, Types::Coercible::String
    end
  end
end