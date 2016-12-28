require 'test_helper'

class EmptyTestSchema < JSONSchema
end

class JSONSchemaTest < ActiveSupport::TestCase
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
      property :foo, type: :string
      properties :bar, :baz, type: :object
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
      string :foo, :bar, required: true
    end
    schema = StringTestSchema.new
    assert_equal :foo,    schema.property(:foo).name
    assert_equal :string, schema.property(:foo).type
    assert_equal :bar,    schema.property(:bar).name
    assert_equal :string, schema.property(:bar).type
    assert_equal [:foo, :bar], schema.required
  end

  test 'required' do
    assert_empty EmptyTestSchema.new.required

    class NoReqTestSchema < JSONSchema
      properties :foo, :bar
    end
    schema = NoReqTestSchema.new
    assert_empty schema.required
    refute_includes schema.as_json, :required

    class ReqTestSchema < JSONSchema
      properties :foo, :bar, required: true
      property :baz
      property :quux, required: true
    end
    schema = ReqTestSchema.new
    assert_equal [:foo, :bar, :quux], schema.required
    assert_equal [:foo, :bar, :quux], schema.as_json[:required]
  end

  test 'Property' do
    foo = JSONSchema::Property.new(:foo)
    assert_equal :foo, foo.name
    assert_nil foo.type
    refute_predicate foo, :required?
    refute_predicate foo, :null?
    assert_nil foo.all_of
    assert_equal({}, foo.as_json)

    str = JSONSchema::Property.new(:foo, type: :string)
    assert_equal :string, str.type
    assert_equal({ type: :string }, str.as_json)

    null_str = JSONSchema::Property.new(:foo, type: :string, null: true)
    assert_equal :string, null_str.type
    assert_predicate null_str, :null?
    assert_equal({ type: [:string, :null] }, null_str.as_json)

    req = JSONSchema::Property.new(:foo, required: true)
    assert req.required?

    schemas_json = [{ '$ref': 'ref-uri' }, { required: [:foo] }]
    all_of = JSONSchema::Property.new(:foo, all_of: schemas_json)
    assert_equal schemas_json, all_of.all_of
    assert_equal({ allOf: schemas_json }, all_of.as_json)
  end
end
