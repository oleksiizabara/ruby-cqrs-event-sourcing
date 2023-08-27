module TeamQueries
  class Show < ::Query
    attribute :initiator, Types.Instance(::User)
    attribute :data do
      attribute :id, Types::Coercible::String.default(nil)
      attribute :game_type_id, Types::Coercible::String.default(nil)
    end
  end
end
