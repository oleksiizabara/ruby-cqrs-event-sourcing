module ChatQueries
  class Messages < ::Query
    attribute :initiator, Types::Instance(::User)
    attribute :data do
      attribute :room_id, Types::Coercible::String
    end
  end
end