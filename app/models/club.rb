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

  class ActiveRecord_Relation
    # When a request comes in like '/clubs?include=contact-profiles', ClubResource calls
    # Club.all.includes(:contact_profiles) in order to preload the associated records, which breaks because there
    # is no association with that name. So we override includes here and remove :contact_profiles from its
    # arguments.
    # TODO: is there a way to do the preload anyway?
    # TODO: what about '?include=clubs.contact-profiles' on some other resource?
    def includes(*args)
      # TODO: handle when args has a Hash, e.g. '?include=contact-profiles.games'
      # ...although I doubt that there is a use case for that.
      super(args.flatten - [:contact_profiles])
    end
  end
end
