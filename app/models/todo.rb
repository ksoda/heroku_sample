# frozen_string_literal: true

class Todo < ApplicationRecord
  has_many :items, dependent: :destroy
  belongs_to :owner,
             class_name: 'User',
             foreign_key: 'user_id',
             inverse_of: :todos

  validates :title, presence: true
end
