# frozen_string_literal: true

module JsonWebToken
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  def self.init(secret:)
    raise ArgumentError unless secret
    @hmac_secret = secret
  end

  def self.hmac_secret
    @hmac_secret
  end

  def self.encode(payload, exp = 24.hours.from_now)
    # set expiry to 24 hours from creation time
    payload[:exp] = exp.to_i
    # sign token with application secret
    # binding.pry
    JWT.encode(payload, hmac_secret)
  end

  def self.decode(token)
    # get payload; first index in decoded Array
    body = JWT.decode(token, hmac_secret)[0]
    HashWithIndifferentAccess.new body
    # rescue from all decode errors
  rescue JWT::DecodeError => e
    # raise custom error to be handled by custom handler
    raise JsonWebToken::InvalidToken, e.message
  end
end
