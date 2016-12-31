require 'test_helper'

class HALSchemaTest < ActiveSupport::TestCase
  class TestHALSchema < HALSchema
    link :foo
    links :bar, :baz
  end

  setup do
    @schema = TestHALSchema.new
  end

  test 'is a JSON Schema' do
    assert_kind_of JSONSchema, @schema
  end

  test 'links' do
    class EmptyHALSchema < HALSchema; end
    assert_equal %i(self), EmptyHALSchema.new.links
    assert_equal %i(self foo bar baz), @schema.links
  end

  test '_links property' do
    assert_kind_of HALSchema::LinksProperty, @schema.property(:_links)
    assert_equal @schema.links, @schema.property(:_links).links
  end

  test '_links is required' do
    assert_includes @schema.required, :_links
  end

  test 'LinksProperty' do
    prop = HALSchema::LinksProperty.new(@schema.class)
    assert_equal :_links, prop.name
    assert_predicate prop, :required?

    links_schemas = prop.as_json[:allOf]
    assert_equal 2, links_schemas.size
    assert_equal 'http://hyperschema.org/mediatypes/hal#/definitions/links', links_schemas[0][:$ref]
    assert_equal %i(self foo bar baz), links_schemas[1][:required]
  end
end
