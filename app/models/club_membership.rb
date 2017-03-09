class ClubMembership < ApplicationRecord
  self.table_name = 'clubmembers'

  belongs_to :club, foreign_key: :clubid
  belongs_to :member, foreign_key: :userid
end
