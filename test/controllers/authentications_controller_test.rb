# frozen_string_literal: true

require 'test_helper'

describe AuthenticationsController do
  include TestSupport

  let(:valid_headers) do
    user = User.find_by!(name: 'John')
    post authentication_url, params: authentication_params(user)
    {
      'Content-Type' => 'application/json',
      'Authorization' => [
        'Token token', parse_json['token']
      ].join('=')
    }
  end

  it 'creates authentication' do
    user = User.find_by!(name: 'John')
    post authentication_url, params: authentication_params(user)
    value(response).must_be :successful?
  end

  it 'destroys authentication' do
    delete authentication_url, headers: valid_headers
    value(response).must_be :successful?
  end
end
