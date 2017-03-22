require 'test_helper'

class GameSchemaTest < ActiveSupport::TestCase
  test_extends ApplicationSchema

  setup do
    @schema = GameSchema.new
  end

  test 'valid schema' do
    assert_valid_json JSON::Validator.default_validator.metaschema, @schema.as_json
  end

  test 'attributes' do
    attrs_prop = @schema.property(:attributes)
    assert_predicate attrs_prop, :required?
    attrs_schema = attrs_prop.schema

    %i(title sort-title author sort-author author-ext tags published version license system language desc
       seriesname seriesnumber genre forgiveness downloadnotes created moddate).each do |attr|
      assert_equal :string, attrs_schema.property(attr).type
    end

    %i(bafsid pagevsn).each do |attr|
      assert_equal :integer, attrs_schema.property(attr).type
    end      

    %i(title sort-title author sort-author created moddate pagevsn).each do |attr|
      assert_predicate attrs_schema.property(attr), :required?
    end

    %i(published created moddate).each do |attr|
      assert_equal 'date-time', attrs_schema.property(attr).format
    end
  end

  test 'relationships' do
    rels = @schema.property(:relationships)

    %i(editor).each do |rel_name|
      rel = rels.schema.property(rel_name)

      rel_links = rel.schema.property(:links)
      assert_predicate rel_links, :required?
      assert_equal %i(self related), rel_links.schema.required

      rel_data = rel.schema.property(:data)
      data_type_prop = rel_data.schema.property(:type)
      assert_equal :members, data_type_prop.value
    end

    # TODO: authors relationship
  end
end
