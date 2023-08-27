module RoomQueryHandlers
  class List < ::QueryHandler
    private

    def perform_query
      @message = RoomProjection.select(:room_id, :users_count, :updated_at, "rooms.name as room_name")
                               .joins(:room).where(rooms: { private: false })
                               .or(RoomProjection.joins(:room).where(rooms: { private: true, owner_id: initiator.id }))
                               .order(updated_at: :desc)
                               .page(data.page)
                               .per(10)
    end
  end
end
