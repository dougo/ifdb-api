require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'Game' do
    assert_kind_of ApplicationRecord, Game.first
  end
end
