module GameEvents
  class GameAutoFinish < ::BaseEvent
    attribute :type, Types::Coercible::String
    attribute :data do
      attribute :game_id, Types::Coercible::String
    end
  end
end