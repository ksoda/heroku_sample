# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_secure_token

  has_many :todos,
           foreign_key: 'created_by',
           dependent: :nullify,
           inverse_of: 'user'

  validates :name, :email, :password_digest, presence: true

  def invalidate_token
    self.token = nil
    save(validate: false)
  end

  def self.find_logined(email, password)
    user = find_by(email: email)
    user if user&.authenticate(password)
  end
end
