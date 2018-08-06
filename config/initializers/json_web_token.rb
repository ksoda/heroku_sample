# frozen_string_literal: true

require 'json_web_token'
JsonWebToken.init(
  # secret: Rails.application.secrets.secret_key_base
  secret: 'aaaa'
)
