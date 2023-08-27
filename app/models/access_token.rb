class AccessToken < ApplicationRecord
  scope :valid, -> { where('expired_at > ?', Time.current) }

  belongs_to :user

  validates :token, presence: true, uniqueness: true

  before_validation :generate_token

  def generate_token
    self.token = SecureRandom.hex(32)
    self.expired_at = 1.month.from_now
  end
end
