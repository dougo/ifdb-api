require 'test_helper'

class ClubMembershipTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should belong_to(:club).with_foreign_key(:clubid)
  should belong_to(:member).with_foreign_key(:userid)
end
