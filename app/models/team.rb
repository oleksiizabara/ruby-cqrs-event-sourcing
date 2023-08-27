class Team < ApplicationRecord
  belongs_to :game_type
  has_many :players, dependent: :destroy
end
