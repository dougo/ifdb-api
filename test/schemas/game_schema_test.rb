require 'test_helper'

class GameSchemaTest < ActiveSupport::TestCase
  setup do
    @schema = GameSchema.new
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
      assert_predicate @schema.property(attr), :required?
    end

    int_attrs = %i(bafsid pagevsn)
    int_attrs.each do |attr|
      assert_equal :integer, @schema.property(attr).type
      assert_predicate @schema.property(attr), :required?
    end

    null_attrs = %i(authorExt tags published version license system language desc coverart seriesname seriesnumber
                    genre forgiveness bafsid website downloadnotes created editedby moddate)
    null_attrs.each do |attr|
      assert_predicate @schema.property(:authorExt), :null?
    end

    datetime_attrs = %i(published created moddate)
    datetime_attrs.each do |attr|
      assert_equal 'date-time', @schema.property(:published).format
    end
  end
end
