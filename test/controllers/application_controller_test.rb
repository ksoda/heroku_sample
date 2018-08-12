# frozen_string_literal: true

require 'test_helper'

describe ApplicationController do
  include TestSupport
  let(:user) { users(:john) }
  before do
    class ::TestingsController < ApplicationController
      def index
        head :no_content
      end
    end

    Rails.application.configure do
      routes.disable_clear_and_finalize = true
      routes.draw do
        resources 'testings', only: 'index'
      end
      routes.disable_clear_and_finalize = false
    end
  end

  after do
    Object.send(:remove_const, :TestingsController)
  end

  describe '#authorize_request' do
    it 'fails when auth token is not passed' do
      get '/testings'
      value(response).must_be :unprocessable?
    end
    it 'sets the current user when auth token is passed' do
      get '/testings', headers: { 'Authorization' => token_generator(user.id) }
      value(response).must_be :successful?
    end
  end
end
