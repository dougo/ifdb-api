require 'test_helper'

class GameSchemaTest < ActiveSupport::TestCase
  setup do
    @schema = GameSchema.new
  end

  test 'superclass' do
    assert_equal ApplicationSchema, GameSchema.superclass
  end

  test 'valid schema' do
    assert_valid_json JSON::Validator.default_validator.metaschema, @schema.as_json
  end

  test 'attributes' do
    attrs_prop = @schema.property(:attributes)
    assert_predicate attrs_prop, :required?
    attrs_schema = attrs_prop.schema

    %i(title sort-title author sort-author author-ext tags published version license system language desc coverart
       seriesname seriesnumber genre forgiveness website downloadnotes created moddate editedby).each do |attr|
      assert_equal :string, attrs_schema.property(attr).type
    end

    %i(bafsid pagevsn).each do |attr|
      assert_equal :integer, attrs_schema.property(attr).type
    end      

    %i(title sort-title author sort-author created moddate editedby pagevsn).each do |attr|
      assert_predicate attrs_schema.property(attr), :required?
    end

    %i(published created moddate).each do |attr|
      assert_equal 'date-time', attrs_schema.property(attr).format
    end

    %i(coverart website).each do |attr|
      assert_equal :uri, attrs_schema.property(attr).format
    end
  end

  # TODO: authors link
end
