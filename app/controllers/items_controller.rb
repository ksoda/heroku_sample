# frozen_string_literal: true

class ItemsController < ApplicationController
  def index
    items = find_todo.items
    render json: items, status: :ok
  end

  def create
    item = find_todo.items.create!(item_params)
    render json: item, status: :created
  end

  def show
    item = find_todo_item find_todo
    render json: item, status: :ok
  end

  private

  def item_params
    params.permit(:name, :done)
  end

  def find_todo
    Todo.find(params[:todo_id])
  end

  def find_todo_item(todo)
    todo.items.find_by!(id: params[:id])
  end
end
