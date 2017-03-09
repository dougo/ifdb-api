class ReviewTag < ApplicationRecord
  self.table_name = 'reviewtags'

  belongs_to :review, foreign_key: :reviewid
end
