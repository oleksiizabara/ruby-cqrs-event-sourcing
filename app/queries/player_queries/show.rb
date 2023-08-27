module PlayerQueries
  class Show < ::Query
    attribute :initiator, Types.Instance(::User)
    attribute :data do
      attribute :id, Types::Coercible::String
    end
  end
end
