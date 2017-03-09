class Club < ApplicationRecord
  has_many :club_memberships, foreign_key: :clubid
  has_many :members, through: :club_memberships
end
