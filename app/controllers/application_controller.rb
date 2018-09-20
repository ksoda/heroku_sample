# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { message: e.message }, status: :not_found
  end

  protect_from_forgery with: :null_session

  private

  def handle_invalid(err)
    render json: { message: err.message }, status: :unprocessable_entity
  end
end
