require 'test_helper'

class GameResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  test_attributes %i(title sort_title author sort_author authorExt tags published version license system language
                     desc coverart seriesname seriesnumber genre forgiveness bafsid website downloadnotes created
                     moddate pagevsn)

  test 'author_profiles relationship' do
    assert_kind_of JSONAPI::Relationship::ToMany, GameResource._relationship(:author_profiles)
  end

  test 'editor relationship' do
    rel = GameResource._relationship(:editor)
    assert_kind_of JSONAPI::Relationship::ToOne, rel
    assert_equal 'Member', rel.class_name
    assert_equal :editedby, rel.foreign_key
  end

  test 'conforms to schema' do
    schema = GameSchema.new
    assert_valid_json schema, serialize(games(:minimal))
    assert_valid_json schema, serialize(games(:maximal))
  end
end
