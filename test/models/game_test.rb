require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'Game' do
    assert_kind_of ApplicationRecord, Game.first
  end

  test 'author_id' do
    assert_nil Game.new.author_id
    assert_equal :xyzzy, Game.new(authorExt: 'Xavier Yzzy {xyzzy}').author_id
    assert_equal [:xyzzy, :plugh], Game.new(authorExt: 'Xavier Yzzy {xyzzy} and Phineas Lugh {plugh}').author_id
  end
end
