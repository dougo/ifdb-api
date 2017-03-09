require 'test_helper'

class MemberTest < ActiveSupport::TestCase 
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should have_and_belong_to_many(:games).join_table('gameprofilelinks')
  should have_many(:lists).class_name('RecommendedList').with_foreign_key(:userid)
  should have_many(:polls).with_foreign_key(:userid)
end
