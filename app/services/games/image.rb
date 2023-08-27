module Games
  class Image
    extend Dry::Initializer

    option :game_snapshot

    def call
      width = 400
      height = 300
      dot_size = 10

      team_1_color = ChunkyPNG::Color.rgb(0,255,0)
      team_2_color = ChunkyPNG::Color.rgb(255,0,0)

      def random_player_color
        ChunkyPNG::Color.rgb(rand(255), rand(255), rand(255))
      end



      image = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::BLACK)

      team1_coords.each do |coord|
        x = coord[:x]
        y = coord[:y]
        image.text(x - 10, y - 10, coord[:id], random_player_color)
      end

      team2_coords.each do |coord|
        x = coord[:x]
        y = coord[:y]
        image.rect(x - dot_size/2, y - dot_size/2, x + dot_size/2, y + dot_size/2, random_player_color, team_2_color)
      end

      image.save('player_coordinates.png')
    end

    private

    def players
      game_snapshot.hgetall(key)["players"]
    end
  end
end