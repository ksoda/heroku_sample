# frozen_string_literal: true

require 'test_helper'

describe User do
  let(:user) { users(:john) }

  it 'must be valid' do
    value(user).must_be :valid?
  end
  it 'has unique email' do
    params = user.attributes.slice('name', 'email', 'password_digest')
    e = proc {
      User.new(params).save(validate: false)
    }.must_raise(ActiveRecord::RecordNotUnique)
    e.message.must_match(/duplicate key value violates unique constraint/)
    e = proc {
      User.create!(params)
    }.must_raise(ActiveRecord::RecordInvalid)
    e.message.must_match(/Email has already been taken/)
  end
end
