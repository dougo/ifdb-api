require 'test_helper'

class CompetitionDivisionTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should belong_to(:competition).with_foreign_key(:compid)
  should have_many(:competition_games).with_foreign_key(:divid)
  should have_many(:games).through(:competition_games)
end
