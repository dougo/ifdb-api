class ClubResource < ApplicationResource
  attributes *%i(name keywords desc contacts contacts_plain members_public members_count)
  attribute :listed, delegate: :created

  has_many :membership
  has_many :contact_profiles, class_name: 'Member', eager_load_on_include: false

  def custom_links(options = {})
    links = super
    links[:website] = _model.url if _model.url.present?
    links
  end

  def members_count
    _model.membership.size
  end

  def self.records(context = {})
    Club.all.includes(:membership)
  end
end
