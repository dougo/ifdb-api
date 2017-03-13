require 'test_helper'

class RecommendedListItemTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should belong_to(:list).class_name('RecommendedList').with_foreign_key(:listid)
  should belong_to(:game).with_foreign_key(:gameid)
end
