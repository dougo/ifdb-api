require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should belong_to(:author).class_name('Member').with_foreign_key(:userid)
  should belong_to(:game).with_foreign_key(:gameid)
  should have_many(:tags).class_name('ReviewTag').with_foreign_key(:reviewid)
  should have_many(:votes).class_name('ReviewVote').with_foreign_key(:reviewid)
  should have_many(:comments).with_foreign_key(:sourceid) # .as(:commentable).with_foreign_type(:source)
end
