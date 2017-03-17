class ClubResource < ApplicationResource
  attributes *%i(name keywords desc contacts contacts_plain created members_public members_count)

  has_many :memberships

  def custom_links(options = {})
    links = super
    links[:website] = _model.url if _model.url.present?
    links
  end

  def members_count
    _model.memberships.size
  end

  def self.records(context = {})
    super.includes(:memberships)
  end
end
