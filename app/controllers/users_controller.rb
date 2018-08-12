# frozen_string_literal: true

require 'message'
class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create
  def create
    user = User.create!(user_params)
    auth = AuthenticateUser.new(user.email, user.password)

    render(
      json: {
        message: Message.account_created,
        auth_token: auth.call
      },
      status: :created
    )
  end

  private

  def user_params
    params.permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end
end
