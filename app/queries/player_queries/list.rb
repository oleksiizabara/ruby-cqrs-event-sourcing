module PlayerQueries
  class List < ::Query
    attribute :initiator, Types.Instance(::User)
    attribute :data do
      attribute :team_id, Types::Coercible::String
    end
  end
end
