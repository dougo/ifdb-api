require 'test_helper'

class EditorialReviewTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should belong_to(:game).with_foreign_key(:gameid)
  should belong_to(:review).with_foreign_key(:reviewid)
end
