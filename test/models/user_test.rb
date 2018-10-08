# frozen_string_literal: true

require 'test_helper'

describe User do
  let(:user) { users(:john) }

  it 'must be valid' do
    value(user).must_be :valid?
  end
  it 'has unique email' do
    e = proc {
      User.create!(
        user.attributes.slice('name', 'email', 'password_digest')
      )
    }.must_raise(ActiveRecord::RecordNotUnique)
    e.message.must_match(/duplicate key value violates unique constraint/)
  end
end
