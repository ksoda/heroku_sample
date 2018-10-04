# frozen_string_literal: true

require 'test_helper'

class AuthenticationsControllerTest < ActionDispatch::IntegrationTest
  it 'creates authentication' do
    post authentication_url(
      email: 'john@example.test', password: 'secret'
    )
    value(response).must_be :successful?
  end

  it 'destroys authentication'
end
