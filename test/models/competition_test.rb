require 'test_helper'

class CompetitionTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should have_many(:news).class_name('NewsItem').with_foreign_key(:sourceid)
    # .as(:newsworthy).with_foreign_type(:source)
  should have_many(:divisions).with_foreign_key(:compid)
  should have_many(:competition_games).with_foreign_key(:compid)
  should have_many(:games).through(:competition_games)
  should have_many(:organizer_competition_members).conditions(role: 'O')
          .class_name('CompetitionMember').with_foreign_key(:compid)
  should have_many(:judge_competition_members).conditions(role: 'J')
          .class_name('CompetitionMember').with_foreign_key(:compid)
  should have_many(:organizer_members).through(:organizer_competition_members).source(:member)
  should have_many(:judge_members).through(:judge_competition_members).source(:member)
  should belong_to(:editor).class_name('Member').with_foreign_key(:editedby)
  should have_many(:history).class_name('CompetitionVersion').with_foreign_key(:compid)
end
