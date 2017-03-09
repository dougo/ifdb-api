require 'test_helper'

class CompetitionTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should have_many(:divisions).with_foreign_key(:compid)
  should have_many(:competition_games).with_foreign_key(:compid)
  should have_many(:games).through(:competition_games)
  should have_many(:organizer_competition_members).conditions(role: 'O')
          .class_name('CompetitionMember').with_foreign_key(:compid)
  should have_many(:judge_competition_members).conditions(role: 'J')
          .class_name('CompetitionMember').with_foreign_key(:compid)
  should have_many(:organizer_members).through(:organizer_competition_members).source(:member)
  should have_many(:judge_members).through(:judge_competition_members).source(:member)
end
