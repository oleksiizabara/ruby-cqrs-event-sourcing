module ChatCommandHandlers
  class NewMessage < ::CommandHandler
    private

    def handle
      message = ::Snapshots::Entries::Message.new(user: initiator.nickname,
                                                  text: data.text,
                                                  created_at: data.created_at)

      ::Snapshots::Recorders::Chat.new(data.room_id).add_message(message)

      push_event
      @success = true
    end

    def push_event
      event = ChatEvents::NewMessage.new(type: 'NewMessage',
                                         data: { user_id: initiator.id,
                                                 text: data.text,
                                                 created_at: data.created_at,
                                                 room_id: data.room_id })
      EventStore::Store.publish('chat', event)
    end
  end
end
