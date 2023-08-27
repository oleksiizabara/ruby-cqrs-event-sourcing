module RoomQueries
  class List < ::Query
    attribute :initiator, Types.Instance(User)
    attribute :data do
      attribute :page, Types::Strict::Integer.default(1)
    end
  end
end
