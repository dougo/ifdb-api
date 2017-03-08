require 'test_helper'

class GameLinkTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should belong_to(:game).with_foreign_key(:gameid)
end
