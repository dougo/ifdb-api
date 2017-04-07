class Review < ApplicationRecord
  belongs_to :reviewer, class_name: 'Member', foreign_key: :userid
  belongs_to :special_reviewer, foreign_key: :special
  belongs_to :game, foreign_key: :gameid
  has_many :tags, class_name: 'ReviewTag', foreign_key: :reviewid
  has_many :votes, class_name: 'ReviewVote', foreign_key: :reviewid
  has_many :comments, as: :commentable, foreign_key: :sourceid, foreign_type: :source
  has_one :offsite_review, foreign_key: :reviewid

  default_scope { order(moddate: :desc) }
  scope :ratings, -> { where.not(rating: nil) }
  scope :editorial_reviews, -> { where.not(special: nil) }
  scope :member_reviews, -> { where.not(review: nil).where(special: nil) }

  # TODO: RFlags: based on older version, not included in average
end
