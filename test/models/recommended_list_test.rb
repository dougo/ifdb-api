require 'test_helper'

class RecommendedListTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should belong_to(:recommender).class_name('Member').with_foreign_key(:userid)
  should have_many(:comments).with_foreign_key(:sourceid) # .as(:commentable).with_foreign_type(:source)
  should have_many(:items).class_name('RecommendedListItem').with_foreign_key(:listid)
end
