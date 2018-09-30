# frozen_string_literal: true

require 'test_helper'

describe Item do
  let(:item) { items(:irondish) }

  it 'must be valid' do
    value(item).must_be :valid?
  end
end
