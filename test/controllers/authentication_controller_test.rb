# frozen_string_literal: true

require 'test_helper'

describe AuthenticationController do
  include TestSupport
  describe 'POST /auth/login' do
    let(:user) { users(:john) }

    it 'returns an authentication token when request is valid' do
      post(
        '/auth/login',
        params: { email: user.email, password: 'secret' }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
      value(parse_json['auth_token']).wont_be :nil?
    end

    it 'returns a failure message when request is invalid' do
      post(
        '/auth/login',
        params: { email: 'blahblah@example.test', password: 'invalid' }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
      value(parse_json['message']).must_match(/Invalid credentials/)
    end
  end
end
