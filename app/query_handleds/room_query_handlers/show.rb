module RoomQueryHandlers
  class Show < ::QueryHandler
    def perform_query
      @message = RoomProjection.select(:room_id, :users_count, :updated_at, "rooms.name as room_name")
                               .joins(:room)
                               .where(room_id: data.room_id)
                               .first
    end
  end
end
