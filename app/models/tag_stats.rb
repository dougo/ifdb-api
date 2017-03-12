class TagStats < ApplicationRecord
  self.table_name = 'tagstats'
  self.primary_key = 'tag'

  has_many :game_tags, foreign_key: :tag
  has_many :games, through: :game_tags
end
