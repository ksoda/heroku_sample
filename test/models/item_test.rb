# frozen_string_literal: true

require 'test_helper'

describe Item do
  let(:item) { Item.new }

  it 'must be valid' do
    value(todos(:one).items.first).must_be :valid?
  end

  it 'must be invalid when no todo' do
    value(item).wont_be :valid?
  end
end
