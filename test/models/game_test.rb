require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should have_and_belong_to_many(:authors).class_name('User').join_table('gameprofilelinks')
  should belong_to(:editor).class_name('User').with_foreign_key(:editedby)
  should have_many(:links).class_name('GameLink').with_foreign_key(:gameid)
  should have_many(:list_items).class_name('RecommendedListItem').with_foreign_key(:gameid)
  should have_many(:lists).through(:list_items)
end
