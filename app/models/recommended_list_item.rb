class RecommendedListItem < ApplicationRecord
  self.table_name = 'reclistitems'

  belongs_to :list, class_name: 'RecommendedList', foreign_key: :listid
  belongs_to :game, foreign_key: :gameid
end
