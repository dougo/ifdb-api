require 'test_helper'

class GameTagTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should belong_to(:game).with_foreign_key(:gameid)
  should belong_to(:tagger).class_name('Member').with_foreign_key(:userid)
  should belong_to(:stats).class_name('TagStats').with_foreign_key(:tag)
end
