module UserQueryHandlers
  class UserByEmail < ::QueryHandler
    private

    def perform_query
      @message = User.find_by(email: query.data.email)
    end
  end
end
