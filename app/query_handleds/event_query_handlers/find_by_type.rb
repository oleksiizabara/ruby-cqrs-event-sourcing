module EventQueryHandlers
  class FindByType < ::QueryHandler
    private

    def perform_query
      @message = ::Event.where(room_id: data.room_id, event_type: data.type)
    end
  end
end
