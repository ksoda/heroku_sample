# frozen_string_literal: true

class AuthorizeApiRequest
  class Message
    def self.missing_token
      'Missing token'
    end

    def self.invalid_token
      'Invalid token'
    end
  end
  def initialize(headers = {})
    @headers = headers
  end

  # Service entry point - return valid user object
  def call
    { user: user }
  end

  private

  attr_reader :headers

  def user
    decoded_auth_token = JsonWebToken.decode(http_auth_header)
    return unless decoded_auth_token
    User.find_by(id: decoded_auth_token[:user_id]) || raise(
      JsonWebToken::InvalidToken,
      "#{Message.invalid_token} Couldn't find User"
    )
  end

  def http_auth_header
    auth = headers['Authorization']
    return auth.split(' ').last if auth.present?
    raise(JsonWebToken::MissingToken, Message.missing_token)
  end
end
