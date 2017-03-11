class IFID < ApplicationRecord
  belongs_to :game, foreign_key: :gameid

  def to_s
    ifid
  end
end
