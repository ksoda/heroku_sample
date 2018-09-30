# frozen_string_literal: true

require 'test_helper'

describe ItemsController do
  include TestSupport
  let(:todo_id) do
    todo = todos(:work)
    todo.id
  end

  let(:valid_headers) do
    {
      'Content-Type' => 'application/json'
    }
  end

  describe 'GET /todos/:todo_id/items' do
    it 'returns all todo items when todo exists' do
      get "/todos/#{todo_id}/items", headers: valid_headers
      value(response).must_be :successful?
    end
  end

  describe 'POST /todos/:todo_id/items' do
    it 'returns status code 201 when request attributes are valid' do
      post(
        "/todos/#{todo_id}/items",
        params: { name: 'Visit Osorezan', done: false }.to_json,
        headers: valid_headers
      )

      value(response).must_be :created?
    end
  end

  describe 'GET /todos/:todo_id/items/:id' do
    it 'returns the item when todo item exists' do
      post(
        "/todos/#{todo_id}/items",
        params: { name: 'Visit Osorezan', done: false }.to_json,
        headers: valid_headers
      )
      id = parse_json['id']

      get "/todos/#{todo_id}/items/#{id}", headers: valid_headers
      value(response).must_be :successful?
      value(parse_json['id']).must_be :eql?, id
    end
  end
end
