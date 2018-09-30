# frozen_string_literal: true

class AddConstraintsToTodo < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:todos, :title, false)
    change_column_null(:todos, :created_by, false)
    change_column_null(:items, :name, false)
  end
end
