# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_secure_token

  has_many :todos,
           dependent: :destroy,
           foreign_key: 'user_id',
           inverse_of: :owner

  validates :name, :email, :password_digest, presence: true
  validates :email, uniqueness: true

  def invalidate_token
    self.token = nil
    save(validate: false)
  end

  def self.find_logined(email, password)
    user = find_by(email: email)
    user if user&.authenticate(password)
  end
end
