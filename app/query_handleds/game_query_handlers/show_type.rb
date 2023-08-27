module GameQueryHandlers
  class ShowType < ::QueryHandler
    def perform_query
      @message = GameType.find(data.id)
    end
  end
end
