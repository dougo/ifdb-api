require 'test_helper'

class JSONSchemaTest < ActiveSupport::TestCase
  class DSLTestSchema < JSONSchema
    type :object
    property :foo
    properties :bar, :baz
    string :str
    integer :int
    required :req
    extend 'http://example.com/schema'
  end

  test 'class DSL methods delegate to _builder' do
    b = DSLTestSchema._builder
    assert_kind_of JSONSchema::Builder, b
    assert_equal :object, b._type
    assert_equal [:foo, :bar, :baz, :str, :int], b._properties.map(&:name)
    assert_equal [:req], b._required
    assert_equal 'http://example.com/schema', b.base
  end

  test 'class builder is top_level' do
    assert_predicate DSLTestSchema._builder, :top_level?
  end

  test 'schema_uri' do
    assert_nil JSONSchema.new.schema_uri
    draft4_uri = JSON::Validator.validator_for_name(:draft4).uri
    assert_equal draft4_uri, JSONSchema.new { top_level }.schema_uri
  end

  test 'type' do
    assert_nil JSONSchema.new.type
    assert_equal :object, JSONSchema.new { type :object }.type
  end

  test 'property and properties' do
    schema = JSONSchema.new { properties :foo, :bar }
    assert_equal [schema.property(:foo), schema.property(:bar)], schema.properties
  end

  test 'required' do
    assert_empty JSONSchema.new.required
    assert_empty JSONSchema.new { properties :foo, :bar, required: false }.required

    schema = JSONSchema.new do
      properties :foo, :bar
      property :baz, required: false
      property :quux
      required :garply
    end
    assert_equal [:foo, :bar, :quux, :garply], schema.required
  end

  test 'base' do
    assert_nil JSONSchema.new.base
    assert_equal '#foo', JSONSchema.new { extend '#foo' }.base
  end

  test 'as_json' do
    json = JSONSchema.new.as_json
    refute_includes json, :$schema
    refute_includes json, :type
    refute_includes json, :properties
    refute_includes json, :required
    refute_includes json, :allOf

    schema = JSONSchema.new do
      top_level
      type :object
      string :foo
      properties :bar, :baz
      extend 'http://example.com/schema'
    end
    expected = {
      '$schema': schema.schema_uri.to_s,
      type: :object,
      properties: {
        foo: schema.property(:foo).as_json,
        bar: schema.property(:bar).as_json,
        baz: schema.property(:baz).as_json
      },
      required: [:foo, :bar, :baz],
      allOf: [{ '$ref': 'http://example.com/schema' }]
    }
    assert_equal expected, schema.as_json
  end

  test 'Builder defaults' do
    b = JSONSchema::Builder.new
    refute_predicate b, :top_level?
    assert_nil b._type
    assert_empty b._properties
    assert_empty b._required
    assert_nil b.base
  end

  test 'Builder#top_level' do
    b = JSONSchema::Builder.new
    b.top_level
    assert_predicate b, :top_level?
  end

  test 'Builder#type' do
    b = JSONSchema::Builder.new
    b.type :object
    assert_equal :object, b._type
  end

  test 'Builder#properties' do
    b = JSONSchema::Builder.new
    b.property :foo, type: :string, null: false
    b.properties :bar, :baz, type: :object, null: false
    assert_equal :foo,    b._properties[0].name
    assert_equal :string, b._properties[0].type
    assert_equal :bar,    b._properties[1].name
    assert_equal :object, b._properties[1].type
    assert_equal :baz,    b._properties[2].name
    assert_equal :object, b._properties[2].type

    q = JSONSchema::Property.new(:quux)
    b._add_property(q)
    assert_equal q, b._properties.last
  end

  test 'Builder#string' do
    b = JSONSchema::Builder.new
    b.string :foo, :bar, required: false do end
    assert_equal :foo,         b._properties[0].name
    assert_equal :string,      b._properties[0].type
    refute_predicate           b._properties[0], :required?
    assert_kind_of JSONSchema, b._properties[0].schema
    assert_equal :bar,         b._properties[1].name
  end

  test 'Builder#integer' do
    b = JSONSchema::Builder.new
    b.integer :foo, :bar, required: false do end
    assert_equal :foo,         b._properties[0].name
    assert_equal :integer,     b._properties[0].type
    refute_predicate           b._properties[0], :required?
    assert_kind_of JSONSchema, b._properties[0].schema
    assert_equal :bar,         b._properties[1].name
  end

  test 'Builder#required' do
    b = JSONSchema::Builder.new
    b.required :foo, :bar
    b.required :baz
    assert_equal [:foo, :bar, :baz], b._required
  end

  test 'Builder#extend' do
    b = JSONSchema::Builder.new
    b.extend 'http://example.com/schema'
    assert_equal 'http://example.com/schema', b.base
  end

  test 'Property' do
    foo = JSONSchema::Property.new(:foo)
    assert_equal :foo, foo.name
    assert_nil foo.type
    assert_predicate foo, :required?
    assert_predicate foo, :null?
    assert_nil foo.format
    assert_nil foo.max_length
    assert_equal({}, foo.as_json)
  end

  test 'Property#type' do
    str = JSONSchema::Property.new(:foo, type: :string)
    assert_equal :string, str.type
    assert_equal [:string, :null], str.as_json[:type]
  end

  test 'Property#null?' do
    null_str = JSONSchema::Property.new(:foo, type: :string, null: false)
    refute_predicate null_str, :null?
    assert_equal :string, null_str.as_json[:type]
  end

  test 'Property#required?' do
    req = JSONSchema::Property.new(:foo, required: false)
    refute_predicate req, :required?
  end

  test 'Property#format' do
    datetime = JSONSchema::Property.new(:foo, format: 'date-time')
    assert_equal 'date-time', datetime.format
    assert_equal 'date-time', datetime.as_json[:format]
  end

  test 'Property#max_length' do
    prop = JSONSchema::Property.new(:foo, max_length: 1)
    assert_equal 1, prop.max_length
    assert_equal 1, prop.as_json[:maxLength]
  end

  test 'Property#schema' do
    assert_nil JSONSchema::Property.new(:foo).schema
    prop = JSONSchema::Property.new(:foo, type: :object, null: false) { string :bar, null: false }
    assert_kind_of JSONSchema, prop.schema
    assert_equal :string, prop.schema.property(:bar).type
    assert_equal :string, prop.as_json[:properties][:bar][:type]
    assert_equal :object, prop.as_json[:type]
  end
end
