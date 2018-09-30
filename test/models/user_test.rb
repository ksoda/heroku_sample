# frozen_string_literal: true

require 'test_helper'

describe User do
  let(:user) { users(:john) }

  it 'must be valid' do
    value(user).must_be :valid?
  end
end
