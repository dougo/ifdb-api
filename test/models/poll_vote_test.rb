require 'test_helper'

class PollVoteTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should belong_to(:poll).with_foreign_key(:pollid)
  should belong_to(:game).with_foreign_key(:gameid)
  should belong_to(:voter).class_name('User').with_foreign_key(:userid)
end
