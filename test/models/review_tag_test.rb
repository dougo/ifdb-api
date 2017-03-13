require 'test_helper'

class ReviewTagTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should belong_to(:review).with_foreign_key(:reviewid)
end
