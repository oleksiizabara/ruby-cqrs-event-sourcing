module GameEventHandlers
  class UserLeftGame < GameFinished
    private

    def finish_event
      ::Games::Finisher::USER_LEFT
    end
  end
end
