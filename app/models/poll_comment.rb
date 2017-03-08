class PollComment < ApplicationRecord
  self.table_name = 'pollcomments'

  belongs_to :poll, foreign_key: :pollid
  belongs_to :game, foreign_key: :gameid
end
