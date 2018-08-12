# frozen_string_literal: true

require 'test_helper'

describe AuthenticationController do
  def json
    JSON.parse(response.body)
  end
  describe 'POST /auth/login' do
    let(:user) do
      User.first.tap { |u| u.update!(password: 'a') }
    end

    it 'returns an authentication token when request is valid' do
      post(
        '/auth/login',
        params: { email: user.email, password: user.password }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
      value(json['auth_token']).wont_be :nil?
    end

    it 'returns a failure message when request is invalid' do
      post(
        '/auth/login',
        params: { email: 'blahblah@example.test', password: 'invalid' }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
      value(json['message']).must_match(/Invalid credentials/)
    end
  end
end
