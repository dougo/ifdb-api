class GameVersion < Version
  self.table_name = 'games_history'

  belongs_to :game, foreign_key: :id
end
