# frozen_string_literal: true

require 'test_helper'

describe AuthenticateUser do
  def described_class
    AuthenticateUser
  end
  let(:user) do
    User.first.tap { |u| u.update!(password: 'a') }
  end

  describe '#call' do
    it 'returns an auth token when valid credentials' do
      value(
        described_class.new(
          user.email, user.password
        ).call
      ).wont_be :nil?
    end
    it 'raises an authentication error when invalid credentials' do
      e = proc {
        described_class.new(
          'foo', 'bar'
        ).call
      }.must_raise(JsonWebToken::AuthenticationError)
      e.message.must_match(/Invalid credentials/)
    end
  end
end
