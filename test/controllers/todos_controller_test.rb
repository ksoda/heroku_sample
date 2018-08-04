# frozen_string_literal: true

require 'test_helper'

describe TodosController do
  it 'must be a real test' do
    get '/todos'
    value(response).must_be :successful?
  end
end
