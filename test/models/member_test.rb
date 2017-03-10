require 'test_helper'

class MemberTest < ActiveSupport::TestCase 
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should have_many(:comments).with_foreign_key(:sourceid) # .as(:commentable).with_foreign_type(:source)
  should have_and_belong_to_many(:games).join_table('gameprofilelinks')
  should have_many(:reviews).with_foreign_key(:userid)
  # TODO: discussions
  should have_many(:club_memberships).with_foreign_key(:userid)
  should have_many(:clubs).through(:club_memberships)
  should have_many(:lists).class_name('RecommendedList').with_foreign_key(:userid)
  should have_many(:polls).with_foreign_key(:userid)
  should have_and_belong_to_many(:played_games).class_name('Game').join_table('playedgames')
  should have_and_belong_to_many(:wishlist).class_name('Game').join_table('wishlists')
  should have_and_belong_to_many(:unwishlist).class_name('Game').join_table('unwishlists')
  # TODO: catalog contributions
  # TODO: user filters
  # TODO: frequent fiction points?
end
