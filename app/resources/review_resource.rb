class ReviewResource < ApplicationResource
  attributes *%i(summary review rating createdate moddate embargodate)

  has_one :game, foreign_key: :gameid
  has_one :reviewer, foreign_key: :userid
  has_one :special_reviewer, foreign_key: :special
  has_one :offsite_review, foreign_key_on: :related

  def self.created_field
    :moddate
  end
end
