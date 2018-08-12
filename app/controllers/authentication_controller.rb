# frozen_string_literal: true

class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate
  def authenticate
    auth_token =
      AuthenticateUser.new(auth_params[:email], auth_params[:password]).call

    render json: { auth_token: auth_token }, status: :ok
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
