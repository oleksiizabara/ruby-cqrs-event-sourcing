module ChatQueryHandlers
  class Messages < ::QueryHandler
    private

    def perform_query
      @message = ::Snapshots::Readers::Chat.new(data.room_id).messages
    end
  end
end