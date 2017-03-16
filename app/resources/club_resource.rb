class ClubResource < ApplicationResource
  attributes *%i(name keywords desc contacts contacts_plain created members_public)

  has_many :memberships

  def custom_links(options = {})
    links = super
    links[:web_site] = _model.url if _model.url.present?
    links
  end
end
