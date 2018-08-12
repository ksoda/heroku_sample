# frozen_string_literal: true

require 'test_helper'

describe AuthorizeApiRequest do
  include TestSupport
  def described_class
    AuthorizeApiRequest
  end

  def expired_token_generator(user_id)
    JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
  end
  let(:request_obj) do
    described_class.new(
      'Authorization' => token_generator(user.id)
    )
  end

  # FIXME: load dynamic methods
  let(:user) { User.find_by!(name: 'John') }

  describe '#call' do
    it 'returns user object when valid request' do
      value(request_obj.call[:user]).must_equal user
    end

    describe 'invalid request' do
      it 'raises a MissingToken error when missing token' do
        e = proc {
          described_class.new({}).call
        }.must_raise(JsonWebToken::MissingToken)
        e.message.must_equal 'Missing token'
      end
      it 'raises an InvalidToken error when invalid token' do
        e = proc {
          described_class.new(
            'Authorization' => token_generator(5)
          ).call
        }.must_raise(JsonWebToken::InvalidToken)
        e.message.must_match(/Invalid token/)
      end
      it 'raises JsonWebToken::ExpiredSignature error when token is expired' do
        e = proc {
          described_class.new(
            'Authorization' => expired_token_generator(user.id)
          ).call
        }.must_raise(JsonWebToken::InvalidToken)
        e.message.must_match(/Signature has expired/)
      end
      it 'handles JWT::DecodeError with fake token' do
        e = proc {
          described_class.new(
            'Authorization' => 'foobar'
          ).call
        }.must_raise(JsonWebToken::InvalidToken)
        e.message.must_match(/Not enough or too many segments/)
      end
    end
  end
end
