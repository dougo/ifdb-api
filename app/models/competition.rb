class Competition < ApplicationRecord
  has_many :divisions, class_name: 'CompetitionDivision', foreign_key: :compid
  has_many :competition_games, foreign_key: :compid
  has_many :games, through: :competition_games
  has_many :organizer_competition_users, ->{ where(role: 'O') },
           class_name: 'CompetitionUser', foreign_key: :compid
  has_many :judge_competition_users, ->{ where(role: 'J') },
           class_name: 'CompetitionUser', foreign_key: :compid
  has_many :organizer_users, through: :organizer_competition_users, source: :user
  has_many :judge_users, through: :judge_competition_users, source: :user
end
