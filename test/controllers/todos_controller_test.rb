# frozen_string_literal: true

require 'test_helper'

describe TodosController do
  def json
    JSON.parse(response.body)
  end
  describe 'GET /todos' do
    it 'returns todos' do
      get '/todos'
      value(response).must_be :successful?
    end
  end

  it 'returns todos' do
    size = lambda {
      get '/todos'
      json.size
    }

    before_size = size.call
    post '/todos', params: { title: 'title', created_by: 'John' }
    size.call.wont_be :eql?, before_size
  end
end
