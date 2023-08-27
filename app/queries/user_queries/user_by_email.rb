module UserQueries
  class UserByEmail < ::Query
    attribute :initiator, Types::Any.default(nil)
    attribute :data do
      attribute :email, Types::String
    end
  end
end
