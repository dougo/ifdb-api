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
    assert_equal :foo, foo.rel
    assert_predicate foo, :required?

    bar = HALSchema::Link.new(:bar, required: false)
    refute_predicate bar, :required?
  end

  test 'Link#as_json' do
    foo = HALSchema::Link.new(:foo).as_json
    assert_equal 'http://hyperschema.org/mediatypes/hal#/definitions/linkObject', foo[:$ref]
  end

  test 'links' do
    class EmptyHALSchema < HALSchema; end
    assert_equal %i(self), EmptyHALSchema.new.links.map(&:rel)
    assert_equal %i(self foo bar baz), @schema.links.map(&:rel)
    assert_predicate @schema.links[0], :required?
    assert_predicate @schema.links[1], :required?
    refute_predicate @schema.links[2], :required?
    refute_predicate @schema.links[3], :required?
  end

  test '_links property' do
    prop = @schema.property(:_links)
    assert_kind_of HALSchema::LinksProperty, prop
  end

  test 'LinksProperty' do
    prop = HALSchema::LinksProperty.new(@schema.class)
    assert_equal :_links, prop.name
    assert_predicate prop, :required?
    assert_equal @schema.links, prop.links
    assert_equal %i(self foo), prop.required_links
  end

  test 'LinksProperty#as_json' do
    prop = HALSchema::LinksProperty.new(@schema.class)
    links_schemas = prop.as_json[:allOf]
    assert_equal 2, links_schemas.size
    assert_equal 'http://hyperschema.org/mediatypes/hal#/definitions/links', links_schemas[0][:$ref]
    prop.links.each do |link|
      assert_equal link.as_json, links_schemas[1][:properties][link.rel], link.rel
    end
    assert_equal %i(self foo), links_schemas[1][:required]
  end
end
