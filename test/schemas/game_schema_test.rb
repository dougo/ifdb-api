require 'test_helper'

class GameSchemaTest < ActiveSupport::TestCase
  setup do
    @schema = GameSchema.new
  end

  test 'JSONSchema' do
    assert_equal JSONSchema, GameSchema.superclass
  end

  test 'valid schema' do
    assert_valid_json JSON::Validator.default_validator.metaschema, @schema.as_json
  end

  test 'extend JSON API schema' do
    assert_equal 'http://jsonapi.org/schema#/definitions/success', @schema.base
  end

  test 'attributes' do
    attrs_prop = @schema.property(:data).schema.property(:attributes)
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

  test 'links' do
    links_prop = @schema.property(:data).schema.property(:links)
    assert_predicate links_prop, :required?
    assert_equal [:self], links_prop.schema.required

    # TODO: authors
  end
end
