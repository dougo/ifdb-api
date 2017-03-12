class CrossRecommendation < ApplicationRecord
  self.table_name = 'crossrecs'

  belongs_to :from, class_name: 'Game', foreign_key: :fromgame
  belongs_to :to, class_name: 'Game', foreign_key: :togame
  belongs_to :recommender, class_name: 'Member', foreign_key: :userid
end
