module EventQueries
  class FindByType < ::Query
    attribute :data do
      attribute :room_id, Types::Coercible::Integer
      attribute :type, Types::String
    end
  end
end