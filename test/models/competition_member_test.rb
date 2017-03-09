require 'test_helper'

class CompetitionMemberTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should belong_to(:competition).with_foreign_key(:compid)
  should belong_to(:member).with_foreign_key(:userid)
end
