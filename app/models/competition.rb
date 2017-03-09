class Competition < ApplicationRecord
  has_many :divisions, class_name: 'CompetitionDivision', foreign_key: :compid
  has_many :competition_games, foreign_key: :compid
  has_many :games, through: :competition_games
  has_many :organizer_competition_members, ->{ where(role: 'O') },
           class_name: 'CompetitionMember', foreign_key: :compid
  has_many :judge_competition_members, ->{ where(role: 'J') },
           class_name: 'CompetitionMember', foreign_key: :compid
  has_many :organizer_members, through: :organizer_competition_members, source: :member
  has_many :judge_members, through: :judge_competition_members, source: :member
end
