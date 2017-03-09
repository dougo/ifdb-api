require 'test_helper'

class ReviewTagTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should belong_to(:review).with_foreign_key(:reviewid)
end
