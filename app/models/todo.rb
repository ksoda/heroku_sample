# frozen_string_literal: true

class Todo < ApplicationRecord
  has_many :items, dependent: :destroy
end
