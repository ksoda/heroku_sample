# frozen_string_literal: true

class ChangeConstraintsToTodo < ActiveRecord::Migration[5.2]
  def change
    remove_column(:todos, :created_by, :string)
    add_reference(:todos, :user, foreign_key: true)
  end
end
