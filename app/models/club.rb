class Club < ApplicationRecord
  attribute :members_public, :yn_boolean

  has_many :news, as: :newsworthy, class_name: 'NewsItem', foreign_key: :sourceid, foreign_type: :source
  has_many :membership, class_name: 'ClubMembership', foreign_key: :clubid

  def contact_tuids
    contacts ? contacts.scan(/{([^}]+)}/).reduce([], :+) : []
  end

  def contact_profiles
    Member.where(id: contact_tuids)
  end
end
