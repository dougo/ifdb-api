require 'test_helper'

class ApplicationSchemaTest < ActiveSupport::TestCase
  test_extends JSONSchema

  class TestSchema < ApplicationSchema
  end

  setup do
    @schema = TestSchema.new
  end

  test 'extend JSON API schema' do
    assert_equal 'http://jsonapi.org/schema#/definitions/resource', @schema.base
  end

  test 'links' do
    assert_predicate @schema.property(:links), :required?

    link = @schema.property(:links).schema.property(:self)
    refute_nil link, "Should have self link"
    assert_equal :string, link.type
    assert_equal :uri, link.format
    assert_predicate link, :required?
  end

  # TODO: jsonapi link
end
