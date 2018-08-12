# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/rails'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

module TestSupport
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end

  def parse_json
    JSON.parse(response.body)
  end
end
