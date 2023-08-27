module PlayerQueryHandlers
  class Show < ::QueryHandler
    def perform_query
      @message = Player.find(data.id)
    end
  end
end