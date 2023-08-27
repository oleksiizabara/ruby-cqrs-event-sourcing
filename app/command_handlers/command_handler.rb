class CommandHandler
  attr_reader :success, :error, :message

  class Error < StandardError
    attr_reader :code

    def initialize(message = "")
      @code = self.class.name.demodulize.underscore

      super
    end
  end

  def initialize(command)
    @command = command
    @success = false
    @error = nil
    @message = nil
  end

  def perform
    handle

    self
  end

  private

  delegate :initiator, :data, to: :command

  def handle
    raise NotImplementedError
  end

  attr_reader :command
end
