require 'test_helper'

class PollVoteTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should belong_to(:poll).with_foreign_key(:pollid)
  should belong_to(:game).with_foreign_key(:gameid)
  should belong_to(:voter).class_name('Member').with_foreign_key(:userid)
end
