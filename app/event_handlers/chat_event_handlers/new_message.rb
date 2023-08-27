module ChatEventHandlers
  class NewMessage < ::EventHandler
    def handle
      Message.create!(user_id: data.user_id, text: data.text, created_at: data.created_at, room_id: data.room_id)
    end
  end
end
