class Club < ApplicationRecord
  has_many :news, as: :newsworthy, class_name: 'NewsItem', foreign_key: :sourceid, foreign_type: :source
  has_many :club_memberships, foreign_key: :clubid
  has_many :members, through: :club_memberships
end
