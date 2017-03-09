class CompetitionMember < ApplicationRecord
  self.table_name = 'compprofilelinks'

  belongs_to :competition, foreign_key: :compid
  belongs_to :member, foreign_key: :userid
end
