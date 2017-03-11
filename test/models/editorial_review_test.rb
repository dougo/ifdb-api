require 'test_helper'

class EditorialReviewTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should belong_to(:game).with_foreign_key(:gameid)
  should belong_to(:review).with_foreign_key(:reviewid)
end
