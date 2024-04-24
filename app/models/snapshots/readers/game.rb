module Snapshots
  module Readers
    class Game < Base
      def team(user_id)
        teams[user_id]
      end

      def opponent(user_id)
        teams.find { |id, _| id != user_id }&.last
      end

      def teams
        JSON.parse(hgetall(key)["teams"] || '{}').each_with_object({}) do |(user_id, team), teams|
          teams[user_id] = ::Snapshots::Entries::Team.new(team.deep_symbolize_keys)
        end
      end

      def player(team_id, id)
        players(team_id)[id]
      end

      def players(team_id)
        JSON.parse(hgetall(key)["players:#{team_id}"] || '{}').each_with_object({}) do |(id, player), players|
          pl = ::Snapshots::Entries::Player.new(player.deep_symbolize_keys)

          return yield pl if block_given?

          players[id] = ::Snapshots::Entries::Player.new(player.deep_symbolize_keys)
        end
      end

      def bonus(team_id)
        ::Snapshots::Entries::TeamBonus.new(JSON.parse(hgetall(key)["bonuses:#{team_id}"] || '{}').deep_symbolize_keys)
      end

      def strategy(team_id)
        ::Snapshots::Entries::TeamStrategy.new(JSON.parse(hgetall(key)["strategies:#{team_id}"] || '{}').deep_symbolize_keys)
      end

      def events
        lrange("events_#{key}", 0, -1).map do |event|
          ::Snapshots::Entries::Event.new(JSON.parse(event).deep_symbolize_keys)
        end
      end

      def game_type_data
        JSON.parse(get("game_type_data_#{key}"))
      end

      def field_image
        ::Games::Image.new(game_snapshot: self).call
      end
    end
  end
end