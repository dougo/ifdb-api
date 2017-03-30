require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should belong_to(:reviewer).class_name('Member').with_foreign_key(:userid)
  should belong_to(:special).class_name('SpecialReviewer').with_foreign_key(:special)
  should belong_to(:game).with_foreign_key(:gameid)
  should have_many(:tags).class_name('ReviewTag').with_foreign_key(:reviewid)
  should have_many(:votes).class_name('ReviewVote').with_foreign_key(:reviewid)
  should have_many(:comments).with_foreign_key(:sourceid) # .as(:commentable).with_foreign_type(:source)
  should have_one(:editorial).class_name('EditorialReview').with_foreign_key(:reviewid)

  test 'ratings scope omits review-only' do
    assert_same_elements reviews(:of_zork, :rating_only, :editorial), Review.ratings.where(game: games(:zork))
  end

  test 'member_reviews scope omits ratings-only and editorial' do
    assert_same_elements reviews(:of_zork, :review_only), Review.member_reviews.where(game: games(:zork))
  end
end
