class RecommendedList < ApplicationRecord
  self.table_name = 'reclists'

  belongs_to :member, foreign_key: :userid
  has_many :comments, as: :source, foreign_key: :sourceid, foreign_type: :source
  has_many :items, class_name: 'RecommendedListItem', foreign_key: :listid
end
