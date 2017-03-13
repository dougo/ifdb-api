require 'test_helper'

class GameVersionTest < ActiveSupport::TestCase
  test_extends Version

  should belong_to(:game).with_foreign_key(:id)
end
