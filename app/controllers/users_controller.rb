# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  # GET /users/1
  def show
    render 'users/show'
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user.slice(:email, :token), status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.permit(:email, :password, :name)
  end
end
