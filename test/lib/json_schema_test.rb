require 'test_helper'
class JSONSchemaTest < ActiveSupport::TestCase
  class EmptyTestSchema < JSONSchema
  end

  test 'schema_uri' do
    draft4_uri = JSON::Validator.validator_for_name(:draft4).uri
    assert_equal draft4_uri, EmptyTestSchema.new.schema_uri
    assert_equal draft4_uri.to_s, EmptyTestSchema.new.as_json[:$schema]
  end

  test 'type' do
    assert_nil EmptyTestSchema.new.type
    refute_includes EmptyTestSchema.new.as_json, :type

    class ObjectTypeTestSchema < JSONSchema
      type :object
    end
    schema = ObjectTypeTestSchema.new
    assert_equal :object, schema.type
    assert_equal :object, schema.as_json[:type]
  end

  test 'properties' do
    assert_empty EmptyTestSchema.new.properties
    refute_includes EmptyTestSchema.new.as_json, :properties

    class PropTestSchema < JSONSchema
      property :foo, type: :string, null: false
      properties :bar, :baz, type: :object, null: false
    end
    schema = PropTestSchema.new
    assert_equal [schema.property(:foo), schema.property(:bar), schema.property(:baz)], schema.properties
    assert_equal :foo,    schema.property(:foo).name
    assert_equal :string, schema.property(:foo).type
    assert_equal :bar,    schema.property(:bar).name
    assert_equal :object, schema.property(:bar).type
    assert_equal :baz,    schema.property(:baz).name
    assert_equal :object, schema.property(:baz).type

    expected_json = { foo: { type: :string }, bar: { type: :object }, baz: { type: :object } }
    assert_equal expected_json, schema.as_json[:properties]
  end

  test 'string' do
    class StringTestSchema < JSONSchema
      string :foo, :bar, required: false
    end
    schema = StringTestSchema.new
    assert_equal :foo,    schema.property(:foo).name
    assert_equal :string, schema.property(:foo).type
    assert_equal :bar,    schema.property(:bar).name
    assert_equal :string, schema.property(:bar).type
    assert_empty schema.required
  end

  test 'integer' do
    class IntegerTestSchema < JSONSchema
      integer :foo, :bar, required: false
    end
    schema = IntegerTestSchema.new
    assert_equal :foo,     schema.property(:foo).name
    assert_equal :integer, schema.property(:foo).type
    assert_equal :bar,     schema.property(:bar).name
    assert_equal :integer, schema.property(:bar).type
    assert_empty schema.required
  end

  test 'required' do
    assert_empty EmptyTestSchema.new.required

    class NoReqTestSchema < JSONSchema
      properties :foo, :bar, required: false
    end
    schema = NoReqTestSchema.new
    assert_empty schema.required
    refute_includes schema.as_json, :required

    class ReqTestSchema < JSONSchema
      properties :foo, :bar
      property :baz, required: false
      property :quux
    end
    schema = ReqTestSchema.new
    assert_equal [:foo, :bar, :quux], schema.required
    assert_equal [:foo, :bar, :quux], schema.as_json[:required]
  end

  test 'Property' do
    foo = JSONSchema::Property.new(:foo)
    assert_equal :foo, foo.name
    assert_nil foo.type
    assert_predicate foo, :required?
    assert_predicate foo, :null?
    assert_nil foo.all_of
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

  test 'Property#all_of' do
    schemas_json = [{ '$ref': 'ref-uri' }, { required: [:foo] }]
    all_of = JSONSchema::Property.new(:foo, all_of: schemas_json)
    assert_equal schemas_json, all_of.all_of
    assert_equal schemas_json, all_of.as_json[:allOf]
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
end