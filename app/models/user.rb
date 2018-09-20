# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :todos,
           foreign_key: 'created_by',
           dependent: :nullify,
           inverse_of: 'user'

  validates :name, :email, :password_digest, presence: true
end
