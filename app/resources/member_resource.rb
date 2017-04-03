class MemberResource < ApplicationResource
  attributes *%i(name gender location publicemail profile profile_summary)
  attribute :since, delegate: :created

  has_many :games

  def custom_links(options)
    links = super
    if _model.picture.present?
      links[:picture] = add_param(_model.picture, :ldesc)
      links[:thumbnail] = add_param(_model.picture, :thumbnail, '80x80')
      links[:large_thumbnail] = add_param(_model.picture, :thumbnail, '250x250')
    end
    links
  end

  def profile_summary
    if profile && profile.length > 100
      profile[0..99] + '...'
    else
      profile
    end
  end

  private

  def add_param(uri, key, value = nil)
    uri = URI(uri)
    uri.query = Rack::Utils.parse_query(uri.query).merge(key.to_s => value).to_query
    uri.to_s
  end
end
