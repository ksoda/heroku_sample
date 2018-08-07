# frozen_string_literal: true

require 'test_helper'

describe ItemsController do
  def json
    JSON.parse(response.body)
  end
  let(:todo_id) do
    todo = todos(:work)
    todo.id
  end

  describe 'GET /todos/:todo_id/items' do
    it 'returns all todo items when todo exists' do
      get "/todos/#{todo_id}/items"
      value(response).must_be :successful?
    end
  end

  describe 'POST /todos/:todo_id/items' do
    it 'returns status code 201 when request attributes are valid' do
      post "/todos/#{todo_id}/items",
           params: { name: 'Visit Osorezan', done: false }
      value(response).must_be :created?
    end
  end

  describe 'GET /todos/:todo_id/items/:id' do
    it 'returns the item when todo item exists' do
      post "/todos/#{todo_id}/items",
           params: { name: 'Visit Osorezan', done: false }
      id = json['id']

      get "/todos/#{todo_id}/items/#{id}"
      value(response).must_be :successful?
      value(json['id']).must_be :eql?, id
    end
  end
end
