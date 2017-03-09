class CompetitionDivision < ApplicationRecord
  self.table_name = 'compdivs'

  belongs_to :competition, foreign_key: :compid
  has_many :competition_games, foreign_key: :divid
  has_many :games, through: :competition_games
end
