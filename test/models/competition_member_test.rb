require 'test_helper'

class CompetitionMemberTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should belong_to(:competition).with_foreign_key(:compid)
  should belong_to(:member).with_foreign_key(:userid)
end
