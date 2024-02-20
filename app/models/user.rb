require 'securerandom'

class User < ApplicationRecord

  include ActsAsWalletOwner

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { allow_blank: true }

  before_save :generate_token

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(token: random_token)
    end
  end

end
