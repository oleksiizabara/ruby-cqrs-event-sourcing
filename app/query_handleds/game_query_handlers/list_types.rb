module GameQueryHandlers
  class ListTypes < ::QueryHandler
    def perform_query
      @message = GameType.all
    end
  end
end
