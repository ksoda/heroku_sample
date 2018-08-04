# frozen_string_literal: true

require 'test_helper'

describe ItemsController do
  describe 'GET /todos/:todo_id/items' do
    it 'returns all todo items when todo exists'
  end
  describe 'POST /todos/:todo_id/items' do
    it 'returns status code 201 when request attributes are valid'
  end
  describe 'GET /todos/:todo_id/items/:id' do
    it 'returns the item when todo item exists'
  end
end
