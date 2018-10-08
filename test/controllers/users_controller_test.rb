# frozen_string_literal: true

require 'test_helper'

describe UsersController do
  include TestSupport
  it 'creates user' do
    email = SecureRandom.hex(4)
    expect do
      post '/users', params: {
        name: 'foo', email: email, password: 'secret'
      }
    end.must_change 'User.count'

    value(parse_json['email']).must_be :eql?, email
    value(response).must_be :created?
  end
end
