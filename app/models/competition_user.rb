class CompetitionUser < ApplicationRecord
  self.table_name = 'compprofilelinks'

  belongs_to :competition, foreign_key: :compid
  belongs_to :user, foreign_key: :userid
end
