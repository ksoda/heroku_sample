# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/rails'

# 5.2.1.rc1 で修正予定
# https://github.com/blowmage/minitest-rails/issues/209#issuecomment-405034019
Minitest::Rails::TestUnit = Rails::TestUnit

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
