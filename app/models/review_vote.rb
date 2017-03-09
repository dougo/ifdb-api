class ReviewVote < ApplicationRecord
  self.table_name = 'reviewvotes'

  belongs_to :review, foreign_key: :reviewid
end
