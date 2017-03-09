require 'test_helper'

class CompetitionTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should have_many(:divisions).with_foreign_key(:compid)
  should have_many(:competition_games).with_foreign_key(:compid)
  should have_many(:games).through(:competition_games)
  should have_many(:organizer_competition_users).conditions(role: 'O')
          .class_name('CompetitionUser').with_foreign_key(:compid)
  should have_many(:judge_competition_users).conditions(role: 'J')
          .class_name('CompetitionUser').with_foreign_key(:compid)
  should have_many(:organizer_users).through(:organizer_competition_users).source(:user)
  should have_many(:judge_users).through(:judge_competition_users).source(:user)
end
