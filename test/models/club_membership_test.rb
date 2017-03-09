require 'test_helper'

class ClubMembershipTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should belong_to(:club).with_foreign_key(:clubid)
  should belong_to(:member).with_foreign_key(:userid)
end
