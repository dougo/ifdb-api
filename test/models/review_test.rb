require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should belong_to(:member).with_foreign_key(:userid)
  should belong_to(:game).with_foreign_key(:gameid)
  should have_many(:tags).class_name('ReviewTag').with_foreign_key(:reviewid)
  should have_many(:votes).class_name('ReviewVote').with_foreign_key(:reviewid)
end