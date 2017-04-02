class ClubMembershipResource < ApplicationResource
  compound_id %i(clubid userid)

  attributes *%i(joindate admin)

  has_one :club, foreign_key: :clubid
  has_one :member, foreign_key: :userid

  def self.created_field
    :joindate
  end
end
