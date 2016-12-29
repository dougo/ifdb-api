require 'test_helper'

class HALSchemaTest < ActiveSupport::TestCase
  class TestHALSchema < HALSchema
  end

  setup do
    @schema = TestHALSchema.new
  end

  test 'is a JSON Schema' do
    assert_kind_of JSONSchema, @schema
  end

  test 'links' do
    assert_predicate @schema.property(:_links), :required?
    links_schemas = @schema.property(:_links).all_of
    assert_equal 2, links_schemas.size
    assert_equal 'http://hyperschema.org/mediatypes/hal#/definitions/links', links_schemas[0][:$ref]
    assert_includes links_schemas[1][:required], :self
  end
end
