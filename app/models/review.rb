class Review < ApplicationRecord
  belongs_to :reviewer, class_name: 'Member', foreign_key: :userid
  belongs_to :special, class_name: 'SpecialReviewer', foreign_key: :special
  belongs_to :game, foreign_key: :gameid
  has_many :tags, class_name: 'ReviewTag', foreign_key: :reviewid
  has_many :votes, class_name: 'ReviewVote', foreign_key: :reviewid
  has_many :comments, as: :commentable, foreign_key: :sourceid, foreign_type: :source
  has_one :editorial, class_name: 'EditorialReview', foreign_key: :reviewid

  scope :ratings, -> { where.not(rating: nil) }
  scope :member_reviews, -> { where.not(review: nil).where(special: nil) }
end
