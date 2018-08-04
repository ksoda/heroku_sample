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

  describe 'POST /todos' do
    it 'creates a todo' do
      size = lambda {
        get '/todos'
        json.size
      }

      before_size = size.call
      post '/todos', params: { title: 'title', created_by: 'John' }
      value(size.call).wont_be :eql?, before_size
    end

    it 'returns status code 422 when the request is invalid' do
      post '/todos', params: {}
      value(response).must_be :unprocessable?
    end
  end
end
