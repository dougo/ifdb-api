require 'test_helper'

class MemberTest < ActiveSupport::TestCase 
  test_extends ApplicationRecord

  should have_many(:comments).with_foreign_key(:sourceid) # .as(:commentable).with_foreign_type(:source)
  should have_and_belong_to_many(:games).join_table('gameprofilelinks')
  should have_many(:lists).class_name('RecommendedList').with_foreign_key(:userid)
  should have_many(:polls).with_foreign_key(:userid)
  should have_many(:reviews).with_foreign_key(:userid)
  should have_and_belong_to_many(:played_games).class_name('Game').join_table('playedgames')
  should have_and_belong_to_many(:wishlist).class_name('Game').join_table('wishlists')
  should have_and_belong_to_many(:not_interested).class_name('Game').join_table('unwishlists')
  should have_many(:club_memberships).with_foreign_key(:userid)

  # TODO: discussion updates
  # TODO: comment inbox
  should have_many(:posted_comments).class_name('Comment').with_foreign_key(:userid)

  # TODO: catalog contributions
  # TODO: frequent fiction points?

  should have_many(:stylesheets).with_foreign_key(:userid)
  should have_many(:game_tags).with_foreign_key(:userid)
  should have_many(:cross_recommendations).with_foreign_key(:userid)
end
