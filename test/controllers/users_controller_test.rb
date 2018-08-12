# frozen_string_literal: true

require 'test_helper'

describe UsersController do
  include TestSupport
  let(:user) { User.new }

  describe 'POST /signup' do
    describe 'when valid request' do
      before do
        email = 'test_1@example.test'
        pass = 'a'
        valid_attributes =
          {
            name: 'user_1', email: email,
            password: pass, password_confirmation: pass
          }

        post(
          '/signup',
          params: valid_attributes.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
      end

      it 'creates a new user with an authentication token' do
        value(response).must_be :created?
        value(parse_json['message']).must_match(/Account created successfully/)

        value(parse_json['auth_token']).wont_be :nil?
      end
    end

    it 'does not create a new user when invalid request' do
      post(
        '/signup',
        params: {},
        headers: { 'Content-Type' => 'application/json' }
      )
      value(response).must_be :unprocessable?
      value(parse_json['message']).must_match(
        /Validation failed:/
      )
    end
  end
end
