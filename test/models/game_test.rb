require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should belong_to(:editor).class_name('User').with_foreign_key(:editedby)
  should have_many(:links).class_name('GameLink').with_foreign_key(:gameid)

  test 'author_id' do
    assert_nil Game.new.author_id
    assert_equal :xyzzy, Game.new(authorExt: 'Xavier Yzzy {xyzzy}').author_id
    assert_equal [:xyzzy, :plugh], Game.new(authorExt: 'Xavier Yzzy {xyzzy} and Phineas Lugh {plugh}').author_id
  end
end
