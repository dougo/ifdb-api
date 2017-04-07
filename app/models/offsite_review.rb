class OffsiteReview < ApplicationRecord
  self.table_name = 'extreviews'

  belongs_to :game, foreign_key: :gameid
  belongs_to :review, foreign_key: :reviewid
end
