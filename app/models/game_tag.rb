class GameTag < ApplicationRecord
  self.table_name = 'gametags'

  belongs_to :game, foreign_key: :gameid
  belongs_to :tagger, class_name: 'Member', foreign_key: :userid
  belongs_to :stats, class_name: 'TagStats', foreign_key: :tag
end
