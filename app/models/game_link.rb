class GameLink < ApplicationRecord
  self.table_name = 'gamelinks'

  belongs_to :game, foreign_key: :gameid
  belongs_to :file_type, foreign_key: :fmtid
  belongs_to :operating_system, foreign_key: :osid
  belongs_to :operating_system_version, foreign_key: :osvsn
end
