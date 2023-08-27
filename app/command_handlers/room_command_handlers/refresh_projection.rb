module RoomCommandHandlers
  class RefreshProjection < ::CommandHandler
    private

    def handle
      ::RoomProjection.find_by(room_id: data.room_id)
                      .update(users_count: [users_joined_count - users_left_count, 0].max)

    end

    def users_joined_count
      EventQueryHandlers::FindByType.new(query('UserJoined')).execute.message.count
    end

    def users_left_count
      EventQueryHandlers::FindByType.new(query('UserLeft')).execute.message.count
    end

    def query(event_type)
      ::EventQueries::FindByType.new(data: { room_id: data.room_id, type: event_type } )
    end
  end
end
