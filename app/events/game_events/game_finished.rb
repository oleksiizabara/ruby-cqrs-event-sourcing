module GameEvents
  class GameFinished < ::BaseEvent
    attribute :type, Types::Coercible::String
    attribute :data do
      attribute :game_id, Types::Coercible::String
      attribute :finished_at, Types::Params::DateTime | Types::Params::Time
    end
  end
end