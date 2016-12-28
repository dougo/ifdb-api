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
    attrs = %i(id title sort_title author sort_author authorExt tags published)
    attrs.each do |attr|
      assert_equal :string, @schema.property(attr).type, attr
      assert_predicate @schema.property(attr), :required?
    end
    null_attrs = %i(authorExt tags published)
    null_attrs.each do |attr|
      assert_predicate @schema.property(:authorExt), :null?
    end
    assert_equal 'date-time', @schema.property(:published).format
  end

  test 'links' do
    assert_predicate @schema.property(:_links), :required?
    links_schemas = @schema.property(:_links).all_of
    assert_equal 2, links_schemas.size
    assert_equal 'http://hyperschema.org/mediatypes/hal#/definitions/links', links_schemas[0][:$ref]
    assert_includes links_schemas[1][:required], :self
  end
end
