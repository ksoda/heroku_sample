# frozen_string_literal: true

require 'test_helper'

describe Dev::PagesController do
  it 'should get home' do
    get dev_pages_home_url
    value(response).must_be :successful?
  end
end
