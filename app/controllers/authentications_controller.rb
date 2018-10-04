# frozen_string_literal: true

class AuthenticationsController < ApplicationController
  def create
    user = User.find_logined(params[:email], params[:password])
    if user
      user.regenerate_token
      render json: { token: user.token }
    else
      render_unauthorized('Error with your login or password')
    end
  end

  def destroy
    current_user.invalidate_token
    head :ok
  end
end
