module GameQueries
  class TeamPlayers < ::Query
    attribute :initiator, Types::Any
    attribute :data do
      attribute :game_id, Types::Coercible::String
    end
  end
end
