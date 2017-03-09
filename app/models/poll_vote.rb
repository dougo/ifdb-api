class PollVote < ApplicationRecord
  self.table_name = 'pollvotes'

  belongs_to :poll, foreign_key: :pollid
  belongs_to :game, foreign_key: :gameid
  belongs_to :voter, class_name: 'Member', foreign_key: :userid
end
