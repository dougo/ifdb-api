require 'test_helper'

class UserSchemaTest < ActiveSupport::TestCase
  setup do
    @schema = UserSchema.new
  end

  test 'superclass' do
    assert_equal ApplicationSchema, UserSchema.superclass
  end

  test 'valid schema' do
    assert_valid_json JSON::Validator.default_validator.metaschema, @schema.as_json
  end

  test 'attributes' do
    attrs_prop = @schema.property(:attributes)
    assert_predicate attrs_prop, :required?
    attrs = attrs_prop.schema.properties.index_by(&:name)

    %i(name gender publicemail location profile picture created).each do |attr|
      assert_equal :string, attrs[attr].type, attr
    end

    %i(name location created).each do |attr|
      assert_predicate attrs[attr], :required?
    end

    assert_equal 1, attrs[:gender].max_length
    assert_equal :email, attrs[:publicemail].format
    assert_equal :uri, attrs[:picture].format
    assert_equal 'date-time', attrs[:created].format
  end
end
