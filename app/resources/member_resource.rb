class MemberResource < ApplicationResource
  attributes *%i(name gender location publicemail profile profile_summary)
  attribute :since, delegate: :created

  has_many :games

  def custom_links(options)
    links = super
    if _model.picture.present?
      links[:picture] = _model.picture
      thumbnail = URI(_model.picture)
      if thumbnail.query
        thumbnail.query += '&thumbnail=80x80'
      else
        thumbnail.query = 'thumbnail=80x80'
      end
      links[:thumbnail] = thumbnail.to_s
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
end
