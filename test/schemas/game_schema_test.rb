require 'test_helper'

class GameSchemaTest < ActiveSupport::TestCase
  setup do
    @schema = GameSchema.new.as_json
  end

  test 'valid schema' do
    assert_valid_json JSON::Validator.default_validator.metaschema, @schema
  end

  test '$schema and type' do
    assert_equal JSON::Validator.validator_for_name(:draft4).uri.to_s, @schema[:$schema]
    assert_equal :object, @schema[:type]
  end

  test 'attribute properties' do
    props = @schema[:properties]
    attrs = %i(id title sort_title author sort_author)
    required = @schema[:required]
    attrs.each do |attr|
      assert_equal :string, props[attr][:type], attr
      assert_includes required, attr
    end
    assert_includes props[:authorExt][:type], :string
    assert_includes props[:authorExt][:type], :null
    assert_includes required, :authorExt
  end

  test 'links' do
    assert_includes @schema[:required], :_links
    links_schemas = @schema[:properties][:_links][:allOf]
    assert_equal 2, links_schemas.size
    assert_equal 'http://hyperschema.org/mediatypes/hal#/definitions/links', links_schemas[0][:$ref]
    assert_includes links_schemas[1][:required], :self
  end
end
