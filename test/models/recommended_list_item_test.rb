require 'test_helper'

class RecommendedListItemTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should belong_to(:list).class_name('RecommendedList').with_foreign_key(:listid)
  should belong_to(:game).with_foreign_key(:gameid)
end
