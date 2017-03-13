require 'test_helper'

class CompetitionVersionTest < ActiveSupport::TestCase
  test_extends Version

  should belong_to(:competition).with_foreign_key(:compid)
end
