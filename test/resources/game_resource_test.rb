require 'test_helper'

class GameResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  EXPECTED_ATTRS = %i(title sort_title author sort_author authorExt tags published version license system language
                      desc coverart seriesname seriesnumber genre forgiveness bafsid website downloadnotes created
                      moddate pagevsn)

  test 'relationships' do
    rel = resource_class._relationship(:editor)
    assert_kind_of JSONAPI::Relationship::ToOne, rel
    assert_equal 'Member', rel.class_name
    assert_equal :editedby, rel.foreign_key
  end
end
