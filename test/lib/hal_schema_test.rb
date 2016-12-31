require 'test_helper'

class HALSchemaTest < ActiveSupport::TestCase
  class TestHALSchema < HALSchema
    link :foo
    links :bar, :baz, required: false
  end

  setup do
    @schema = TestHALSchema.new
  end

  test 'is a JSON Schema' do
    assert_kind_of JSONSchema, @schema
  end

  test 'Link' do
    foo = HALSchema::Link.new(:foo)
    assert_equal :foo, foo.name
    assert_predicate foo, :required?

    bar = HALSchema::Link.new(:bar, required: false)
    refute_predicate bar, :required?
  end

  test 'links' do
    class EmptyHALSchema < HALSchema; end
    assert_equal %i(self), EmptyHALSchema.new.links.map(&:name)
    assert_equal %i(self foo bar baz), @schema.links.map(&:name)
    assert_predicate @schema.links[0], :required?
    assert_predicate @schema.links[1], :required?
    refute_predicate @schema.links[2], :required?
    refute_predicate @schema.links[3], :required?
  end

  test '_links property' do
    prop = @schema.property(:_links)
    assert_kind_of HALSchema::LinksProperty, prop
    assert_equal @schema.links, prop.links
    assert_equal %i(self foo), prop.required_links
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
    assert_equal %i(self foo), links_schemas[1][:required]
  end
end
