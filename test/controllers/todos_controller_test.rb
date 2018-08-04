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
  describe 'GET /todos/:id' do
    it 'returns the todo' do
      post '/todos', params: { title: 'title', created_by: 'John' }
      id = json['id']
      get "/todos/#{id}"
      value(json['id']).must_be :eql?, id
      value(response).must_be :successful?
    end

    it 'returns status code 404 when the record does not exist' do
      id = Todo.maximum(:id).succ
      get "/todos/#{id}"
      value(response).must_be :not_found?
    end
  end
  describe 'DELETE /todos/:id' do
    it 'returns status code 204' do
      delete "/todos/#{Todo.first.id}"
      value(response).must_be :no_content?
    end
  end
end
