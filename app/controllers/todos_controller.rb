# frozen_string_literal: true

class TodosController < ApplicationController
  before_action :require_login, except: [:index]
  def index
    todos = Todo.take(3)
    render json: todos, status: :ok
  end

  def create
    todo = Todo.new(todo_params)
    todo.owner = current_user
    todo.save!
    render json: todo, status: :created
  end

  def show
    todo = find_todo
    render json: todo, status: :ok
  end

  def destroy
    todo = find_todo
    todo.destroy! # TODO: handle the error
    head :no_content
  end

  private

  def todo_params
    params.permit(:title)
  end

  def find_todo
    Todo.find(params[:id])
  end
end
