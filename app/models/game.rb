class Game < ApplicationRecord
  PENDING = "pending"
  OWNER_READY = "owner_ready"
  WAITING_FOR_OPPONENT = "waiting_for_opponent"
  WAITING_FOR_OPPONENT_LINE_UP = "waiting_for_opponent_line_up"
  IN_PROGRESS = "in_progress"
  FINISHED = "finished"
  SUMMARIZED = "summarized"
  CANCELED = "canceled"
end