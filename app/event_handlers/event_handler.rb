class EventHandler
  def initialize(event)
    @event = event
  end

  def handle
    raise NotImplementedError
  end

  private

  delegate :data, to: :event

  attr_reader :event
end