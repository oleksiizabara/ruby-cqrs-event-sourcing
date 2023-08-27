module Players
  STATS_PER_POSITION = {
    "goalie" => {
      "offense" => (20..50),
      "defense" => (50..70),
      "speed" => (20..50),
      "stamina" => (30..60),
      "health" => (80..100),
      "morale" => (80..100),
      "basic_stats" => %w[defense stamina morale]
    },
    "defense" => {
      "offense" => (20..50),
      "defense" => (50..70),
      "speed" => (50..70),
      "stamina" => (50..70),
      "health" => (80..100),
      "morale" => (80..100),
      "basic_stats" => %w[defense stamina speed]
    },
    "offense" => {
      "offense" => (50..70),
      "defense" => (20..50),
      "speed" => (50..70),
      "stamina" => (50..70),
      "health" => (80..100),
      "morale" => (80..100),
      "basic_stats" => %w[offense stamina speed]
    }
  }

  SUPER_START_CHANCE = 6
  STATS = %w[offense defense speed stamina health]

  class Creator
    def initialize(team_id:, position:, sub_position:, name:, number:, game_type_id:)
      @position = position
      @name = name
      @number = number
      @team = Team.find(team_id)
      @sub_position = sub_position
      @game_type_id = game_type_id
    end

    def call!
      set_stats

      player.save!
    end

    def player
      @player ||= Player.new(position: @position, name: @name, number: @number, team_id: @team.id,
                             sub_position: @sub_position, game_type_id: @game_type_id)
    end

    def set_stats
      stats = STATS.each_with_object({}) do |stat, obj|
        interval = STATS_PER_POSITION[@position][stat]
        obj[stat] = rand(interval)
        if rand(1..100) == SUPER_START_CHANCE && stat.in?(STATS_PER_POSITION[@position]["basic_stats"])
          (100 - interval.last)/2 + interval.last
        end
      end

      player.assign_attributes(stats)
    end
  end
end
