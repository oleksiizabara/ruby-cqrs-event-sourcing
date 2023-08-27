class QueryHandler
  attr_reader :message

  def initialize(query)
    @query = query
  end

  def execute
    perform_query

    self
  end

  private

  def perform_query
    raise NotImplementedError
  end

  delegate :initiator, :data, to: :query

  attr_reader :query
end
