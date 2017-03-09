require 'test_helper'

class CompetitionUserTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should belong_to(:competition), foreign_key: :compid
  should belong_to(:user), foreign_key: :userid
end
