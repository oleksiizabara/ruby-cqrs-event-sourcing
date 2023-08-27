module Snapshots
  module Recorders
    class Game < Base
      def team(team)
        teams = read_model.teams
        teams[team.user_id] = team

        hset(key, "teams", teams.to_json)
      end

      def player(player)
        players = read_model.players(player.team_id)
        players[player.id] = player

        hset(key, "players:#{player.team_id}", players.to_json)
      end

      def bonus(bonus)
        bonuses = read_model.bonuses(bonus.team_id)
        bonuses[bonus.id] = bonus

        hset(key, "bonuses:#{bonus.team_id}", bonuses.to_json)
      end

      def strategy(strategy)
        hset(key, "strategies:#{strategy.team_id}", strategy.to_json)
      end

      def event(event)
        rpush("events_#{key}", event.to_json)
        ltrim("events_#{key}", -20, -1)
      end

      def game_type_data(game_type_data)
        set("game_type_data_#{key}", game_type_data.to_json)
      end

      def clear
        del(key)
        del("events_#{key}")
        del("game_type_data_#{key}")
      end

      private

      def read_model
        @read_model ||= ::Snapshots::Readers::Game.new(unbuilt_key)
      end
    end
  end
end
