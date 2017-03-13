require 'test_helper'

class PollTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should belong_to(:creator).class_name('Member').with_foreign_key(:userid)
  should have_many(:comments).with_foreign_key(:sourceid) # .as(:commentable).with_foreign_type(:source)
  should have_many(:votes).class_name('PollVote').with_foreign_key(:pollid)
  should have_many(:games).through(:votes)
  should have_many(:game_comments).class_name('PollComment').with_foreign_key(:pollid)
end
