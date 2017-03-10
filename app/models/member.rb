class Member < ApplicationRecord
  self.table_name = 'users'

  has_many :comments, as: :commentable, foreign_key: :sourceid, foreign_type: :source
  has_and_belongs_to_many :games, join_table: 'gameprofilelinks', foreign_key: :userid,
                          association_foreign_key: :gameid
  has_many :reviews, foreign_key: :userid
  has_many :club_memberships, foreign_key: :userid
  has_many :clubs, through: :club_memberships
  has_many :lists, class_name: 'RecommendedList', foreign_key: :userid
  has_many :polls, foreign_key: :userid
  has_and_belongs_to_many :played_games, class_name: 'Game', join_table: 'playedgames',
                          foreign_key: :userid, association_foreign_key: :gameid
  has_and_belongs_to_many :wishlist, class_name: 'Game', join_table: 'wishlists',
                          foreign_key: :userid, association_foreign_key: :gameid
  has_and_belongs_to_many :unwishlist, class_name: 'Game', join_table: 'unwishlists',
                          foreign_key: :userid, association_foreign_key: :gameid
end
