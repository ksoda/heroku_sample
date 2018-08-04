# frozen_string_literal: true

require 'test_helper'

describe Todo do
  let(:todo) { todos(:one) }

  it 'must be valid' do
    value(todo).must_be :valid?
  end
end
