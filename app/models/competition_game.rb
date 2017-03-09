class CompetitionGame < ApplicationRecord
  self.table_name = 'compgames'

  belongs_to :competition, foreign_key: :compid
  belongs_to :division, class_name: 'CompetitionDivision', foreign_key: :divid
  belongs_to :game, foreign_key: :gameid
end
