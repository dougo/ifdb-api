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

  test 'editor' do
    editor = Game.reflect_on_association(:editor)
    assert_predicate editor, :belongs_to?
    assert_equal User, editor.klass
    assert_equal :editedby, editor.foreign_key
  end
end
