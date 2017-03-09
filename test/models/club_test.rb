require 'test_helper'

class ClubTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should have_many(:club_memberships).with_foreign_key(:clubid)
  should have_many(:members).through(:club_memberships)
end
