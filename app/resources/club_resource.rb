class ClubResource < ApplicationResource
  attributes *%i(name keywords desc contacts contacts_plain members_public)
  attribute :listed, delegate: :created

  has_many :membership
  has_many :contact_profiles, class_name: 'Member', eager_load_on_include: false

  def custom_links(options)
    links = super
    links['self'] = options[:serializer].link_builder.self_link(self) + '?include=contact-profiles'
    links[:website] = _model.url if _model.url.present?
    links
  end

  def membership_includes
    %w(club member)
  end

  def membership_meta(options)
    { count: _model.membership.size }
  end

  def self.records(context = {})
    Club.all.includes(:membership)
  end
end
