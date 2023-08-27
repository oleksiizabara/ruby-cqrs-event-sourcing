class User < ApplicationRecord
  def authenticate(password)
    Digest::SHA256.hexdigest(password) == encrypted_password
  end

  def password=(value)
    self.encrypted_password = Digest::SHA256.hexdigest(value)
  end
end
