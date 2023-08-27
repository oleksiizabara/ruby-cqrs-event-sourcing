module GameQueries
  class Field < ::Query
    attribute :initiator, Types.Instance(::User)
    attribute :data do
      attribute :game_id, Types::Coercible::String
    end
  end
end