require 'test_helper'

class LanguageTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  test 'find_by id with id2' do
    assert_equal 'en', Language.find_by(id: 'en').id2
  end

  test 'find_by id with id3' do
    assert_equal 'en', Language.find_by(id: 'eng').id2
  end

  test 'find_by id with language code' do
    assert_equal 'en', Language.find_by(id: 'en-US').id2
  end

  test 'find_by id with wrong length' do
    assert_nil Language.find_by(id: 'english')
  end

  test 'find_by name' do
    assert_equal 'en', Language.find_by(name: 'English').id2
  end
end
