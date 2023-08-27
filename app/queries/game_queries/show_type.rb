module GameQueries
  class ShowType < ::Query
    attribute :initiator, Types::Any
    attribute :data do
      attribute :id, Types::Coercible::String
    end
  end
end
