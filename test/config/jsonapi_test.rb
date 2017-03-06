require 'test_helper'

class JSONAPIConfigTest < ActiveSupport::TestCase
  test 'resource key type' do
    assert_equal :string, JSONAPI.configuration.resource_key_type
  end

  test 'resource linkage' do
    assert JSONAPI.configuration.always_include_to_one_linkage_data
  end

  test 'default paginator' do
    assert_equal :paged, JSONAPI.configuration.default_paginator
  end

  test 'default page size' do
    assert_equal 20, JSONAPI.configuration.default_page_size
  end

  test 'maximum page size' do
    assert_equal 100, JSONAPI.configuration.maximum_page_size
  end
end
