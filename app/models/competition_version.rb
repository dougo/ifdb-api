class CompetitionVersion < Version
  self.table_name = 'comps_history'

  belongs_to :competition, foreign_key: :compid
end
