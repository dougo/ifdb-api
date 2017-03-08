require 'test_helper'

class RecommendedListTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should belong_to(:user).with_foreign_key(:userid)
  should have_many(:items).class_name('RecommendedListItem').with_foreign_key(:listid)
end
