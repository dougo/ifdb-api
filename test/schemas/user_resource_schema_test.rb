require 'test_helper'

class UserResourceSchemaTest < ActiveSupport::TestCase
  setup do
    @schema = UserResourceSchema.new
  end

  test 'JSONSchema' do
    assert_equal JSONSchema, UserResourceSchema.superclass
  end

  test 'valid schema' do
    assert_valid_json JSON::Validator.default_validator.metaschema, @schema.as_json
  end

  test 'extend JSON API schema' do
    assert_equal 'http://jsonapi.org/schema#/definitions/success', @schema.base
  end

  test 'attributes' do
    attrs_prop = @schema.property(:data).schema.property(:attributes)
    attrs = attrs_prop.schema.properties.index_by(&:name)

    %i(name gender publicemail location profile picture created).each do |attr|
      assert_equal :string, attrs[attr].type, attr
      assert_predicate attrs[attr], :required?
    end

    %i(name location created).each do |attr|
      refute_predicate attrs[attr], :null?
    end

    assert_equal 1, attrs[:gender].max_length
    assert_equal :email, attrs[:publicemail].format
    assert_equal :uri, attrs[:picture].format
    assert_equal 'date-time', attrs[:created].format
  end

  test 'links' do
    links_prop = @schema.property(:data).schema.property(:links)
    assert_predicate links_prop, :required?
    assert_equal [:self], links_prop.schema.required
  end
end
