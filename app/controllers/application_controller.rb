# frozen_string_literal: true

require 'json_web_token'

class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid
  rescue_from JsonWebToken::AuthenticationError do |e|
    render json: { message: e.message }, status: :unauthorized
  end
  rescue_from JsonWebToken::MissingToken, with: :handle_invalid
  rescue_from JsonWebToken::InvalidToken, with: :handle_invalid
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { message: e.message }, status: :not_found
  end

  private

  def handle_invalid(err)
    render json: { message: err.message }, status: :unprocessable_entity
  end
end
