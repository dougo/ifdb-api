class Game < ApplicationRecord
  has_and_belongs_to_many :authors, class_name: 'User', join_table: :gameprofilelinks,
                          foreign_key: :gameid, association_foreign_key: :userid
  belongs_to :editor, class_name: 'User', foreign_key: :editedby
  has_many :links, class_name: 'GameLink', foreign_key: :gameid
  has_many :list_items, class_name: 'RecommendedListItem', foreign_key: :gameid
  has_many :lists, through: :list_items
  has_many :poll_votes, foreign_key: :gameid
  has_many :polls, -> { distinct }, through: :poll_votes
  has_many :competition_games, foreign_key: :gameid
  has_many :competitions, through: :competition_games
end
