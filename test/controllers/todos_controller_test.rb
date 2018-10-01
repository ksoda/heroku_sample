# frozen_string_literal: true

require 'test_helper'

describe TodosController do
  include TestSupport
  let(:valid_headers) do
    {
      'Content-Type' => 'application/json'
    }
  end

  describe 'GET /todos' do
    it 'returns todos' do
      get '/todos', headers: valid_headers
      value(response).must_be :successful?
    end
  end

  describe 'POST /todos' do
    it 'creates a todo' do
      post(
        '/todos',
        params: { title: 'title', created_by: 'John' }.to_json,
        headers: valid_headers
      )
      value(response).must_be :created?
    end

    it 'returns status code 422 when the request is invalid' do
      skip
      post(
        '/todos',
        params: { title: nil }.to_json,
        headers: valid_headers
      )
      value(response).must_be :unprocessable?
    end
  end

  describe 'GET /todos/:id' do
    it 'returns the todo' do
      post(
        '/todos',
        params: { title: 'title', created_by: 'John' }.to_json,
        headers: valid_headers
      )
      id = parse_json['id']

      get "/todos/#{id}", headers: valid_headers
      value(response).must_be :successful?
      value(parse_json['id']).must_be :eql?, id
    end

    it 'returns status code 404 when the record does not exist' do
      skip
      id = Todo.maximum(:id).succ
      get "/todos/#{id}", headers: valid_headers
      value(response).must_be :not_found?
    end
  end

  describe 'DELETE /todos/:id' do
    it 'returns status code 204' do
      skip
      id = Todo.first.id
      get "/todos/#{id}", headers: valid_headers
      value(response).must_be :successful?

      delete "/todos/#{id}", headers: valid_headers
      value(response).must_be :no_content?

      get "/todos/#{id}", headers: valid_headers
      value(response).must_be :not_found?
    end
  end
end
