class Club < ApplicationRecord
  attribute :members_public, :yn_boolean

  has_many :news, as: :newsworthy, class_name: 'NewsItem', foreign_key: :sourceid, foreign_type: :source
  has_many :memberships, class_name: 'ClubMembership', foreign_key: :clubid
end
