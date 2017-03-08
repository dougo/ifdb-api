require 'test_helper'

class UserTest < ActiveSupport::TestCase 
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should have_many(:lists).class_name('RecommendedList').with_foreign_key(:userid)
end
