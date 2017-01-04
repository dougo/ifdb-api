require 'test_helper'

class UserSchemaTest < ActiveSupport::TestCase
  setup do
    @schema = UserSchema.new
  end

  test 'is a HALSchema' do
    assert_kind_of HALSchema, @schema
  end

  test 'valid schema' do
    assert_valid_json JSON::Validator.default_validator.metaschema, @schema.as_json
  end

  test 'type' do
    assert_equal :object, @schema.type
  end

  test 'attribute properties' do
    str_attrs = %i(id name gender publicemail location profile picture created)
    str_attrs.each do |attr|
      assert_equal :string, @schema.property(attr).type, attr
    end

    required_attrs = %i(id name location)
    required_attrs.each do |attr|
      assert_predicate @schema.property(attr), :required?
    end

    assert_equal 1, @schema.property(:gender).max_length
    assert_equal :email, @schema.property(:publicemail).format
    assert_equal :uri, @schema.property(:picture).format
    assert_equal 'date-time', @schema.property(:created).format
  end
end
