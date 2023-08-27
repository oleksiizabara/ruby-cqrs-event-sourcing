module TeamQueries
  class List < ::Query
    attribute :initiator, Types.Instance(::User)
    attribute :data do
      attribute :game_type_id, Types::Coercible::String.default(nil)
    end
  end
end
