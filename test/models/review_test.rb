require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should belong_to(:reviewer).class_name('Member').with_foreign_key(:userid)
  should belong_to(:special_reviewer).with_foreign_key(:special)
  should belong_to(:game).with_foreign_key(:gameid)
  should have_many(:tags).class_name('ReviewTag').with_foreign_key(:reviewid)
  should have_many(:votes).class_name('ReviewVote').with_foreign_key(:reviewid)
  should have_many(:comments).with_foreign_key(:sourceid) # .as(:commentable).with_foreign_type(:source)
  should have_one(:offsite_review).with_foreign_key(:reviewid)

  test 'default_scope orders by moddate' do
    assert_equal({ moddate: :desc }, relation_order(Review.all))
  end

  test 'ratings scope omits review-only' do
    assert_same_elements reviews(:of_zork, :rating_only, :external), Review.ratings.where(game: games(:zork))
  end

  test 'editorial_reviews scope includes only editorial' do
    # TODO: :from_the_author?
    assert_same_elements reviews(:external, :bafs_guide), Review.editorial_reviews.where(game: games(:zork))
  end

  test 'member_reviews scope omits ratings-only and editorial' do
    assert_same_elements reviews(:of_zork, :review_only), Review.member_reviews.where(game: games(:zork))
  end

  private

  def relation_order(rel)
    rel.order_values.map do |order|
      [order.expr.name, order_type(order)]
    end.to_h
  end

  def order_type(order)
    case order
    when Arel::Nodes::Ascending
      :asc
    when Arel::Nodes::Descending
      :desc
    end
  end
end
