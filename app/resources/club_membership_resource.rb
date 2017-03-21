class ClubMembershipResource < ApplicationResource
  attributes *%i(joindate admin)

  has_one :club, foreign_key: :clubid
  has_one :member, foreign_key: :userid

  primary_key :id

  def id
    [clubid, userid].join '-'
  end

  filter :id, apply: ->(records, id, options) do
    clubids, userids = id.split '-'
    records.where(clubid: clubids, userid: userids)
  end

  def self.created_field
    :joindate
  end
end
