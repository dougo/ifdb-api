class Poll < ApplicationRecord
  belongs_to :creator, class_name: 'Member', foreign_key: :userid
  has_many :comments, as: :commentable, foreign_key: :sourceid, foreign_type: :source
  has_many :votes, class_name: 'PollVote', foreign_key: :pollid
  has_many :games, through: :votes
  has_many :game_comments, class_name: 'PollComment', foreign_key: :pollid
end
