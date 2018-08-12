# frozen_string_literal: true

require 'test_helper'

describe ApplicationController do
  let(:user) { users(:john) }

  describe '#authorize_request' do
    it 'sets the current user when auth token is passed'
    it 'raises MissingToken error when auth token is not passed'
  end
end
