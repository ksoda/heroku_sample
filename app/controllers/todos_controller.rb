# frozen_string_literal: true

class TodosController < ApplicationController
  def index
    todos = Todo.take(3)
    render json: todos, status: :ok
  end

  def create
    todo = Todo.create!(todo_params)
    render json: todo, status: :created
  end

  private

  def todo_params
    params.permit(:title, :created_by)
  end

  def find_todo
    Todo.find(params[:id])
  end
end
