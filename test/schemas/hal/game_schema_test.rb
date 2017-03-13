require 'test_helper'

class HAL::GameSchemaTest < ActiveSupport::TestCase
  test_extends HALSchema

  setup do
    @schema = HAL::GameSchema.new
  end

  test 'valid schema' do
    assert_valid_json JSON::Validator.default_validator.metaschema, @schema.as_json
  end

  test 'type' do
    assert_equal :object, @schema.type
  end

  test 'attribute properties' do
    str_attrs = %i(id title sort_title author sort_author authorExt tags published version license system language
                   desc coverart seriesname seriesnumber genre forgiveness website downloadnotes created editedby
                   moddate)
    str_attrs.each do |attr|
      assert_equal :string, @schema.property(attr).type, attr
    end

    int_attrs = %i(bafsid pagevsn)
    int_attrs.each do |attr|
      assert_equal :integer, @schema.property(attr).type
    end

    nonnull_attrs = %i(id title sort_title author sort_author created editedby moddate pagevsn)
    nonnull_attrs.each do |attr|
      refute_predicate @schema.property(attr), :null?
    end

    datetime_attrs = %i(published created moddate)
    datetime_attrs.each do |attr|
      assert_equal 'date-time', @schema.property(attr).format
    end

    uri_attrs = %i(coverart website)
    uri_attrs.each do |attr|
      assert_equal :uri, @schema.property(attr).format, attr
    end
  end
end
