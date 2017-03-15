class Game < ApplicationRecord
  has_and_belongs_to_many :author_profiles, class_name: 'Member', join_table: :gameprofilelinks,
                          foreign_key: :gameid, association_foreign_key: :userid
  has_many :ratings, -> { ratings }, class_name: 'Review', foreign_key: :gameid
  has_many :reviews_and_ratings, class_name: 'Review', foreign_key: :gameid
  has_many :ifids, class_name: 'IFID', foreign_key: :gameid
  has_many :cross_references, foreign_key: :fromid
  has_many :awards, class_name: 'CompetitionGame', foreign_key: :gameid
  has_many :competitions, through: :awards
  has_many :news, as: :newsworthy, class_name: 'NewsItem', foreign_key: :sourceid, foreign_type: :source
  has_many :editorial_reviews, foreign_key: :gameid
  has_many :game_tags, foreign_key: :gameid
  has_many :tag_stats, through: :game_tags, source: :stats
  has_many :member_reviews, -> { member_reviews }, class_name: 'Review', foreign_key: :gameid
  has_many :cross_recommendations, foreign_key: :fromgame
  has_many :related, through: :cross_recommendations, source: :to
  has_many :list_items, class_name: 'RecommendedListItem', foreign_key: :gameid
  has_many :lists, through: :list_items
  has_many :poll_votes, foreign_key: :gameid
  has_many :polls, -> { distinct }, through: :poll_votes
  belongs_to :editor, class_name: 'Member', foreign_key: :editedby
  has_many :history, class_name: 'GameVersion', foreign_key: :id
  has_many :links, class_name: 'GameLink', foreign_key: :gameid
  has_and_belongs_to_many :players, class_name: 'Member', join_table: :playedgames,
                          foreign_key: :gameid, association_foreign_key: :userid
  has_and_belongs_to_many :wishlists, class_name: 'Member', join_table: :wishlists,
                          foreign_key: :gameid, association_foreign_key: :userid
end
