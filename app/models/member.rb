class Member < ApplicationRecord
  self.table_name = 'users'

  has_and_belongs_to_many :games, join_table: 'gameprofilelinks', foreign_key: :userid,
                          association_foreign_key: :gameid
  has_many :reviews, foreign_key: :userid
  has_many :lists, class_name: 'RecommendedList', foreign_key: :userid
  has_many :polls, foreign_key: :userid
  has_many :club_memberships, foreign_key: :userid
  has_many :clubs, through: :club_memberships
end
