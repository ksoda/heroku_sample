# frozen_string_literal: true

class TodosController < ApplicationController
  def index
    todos = Todo.take(3)
    render json: todos
  end
end
