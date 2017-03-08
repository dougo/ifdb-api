class GameLink < ApplicationRecord
  self.table_name = 'gamelinks'

  belongs_to :game, foreign_key: :gameid
end
