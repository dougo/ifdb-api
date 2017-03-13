require 'test_helper'

class CompetitionGameTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should belong_to(:competition).with_foreign_key(:compid)
  should belong_to(:division).class_name('CompetitionDivision').with_foreign_key(:divid)
  should belong_to(:game).with_foreign_key(:gameid)
end
