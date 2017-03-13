require 'test_helper'

class PollCommentTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should belong_to(:poll).with_foreign_key(:pollid)
  should belong_to(:game).with_foreign_key(:gameid)
end
