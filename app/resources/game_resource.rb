class GameResource < ApplicationResource
  attributes *%i(title sort_title author sort_author authorExt tags published version license system language desc
                 seriesname seriesnumber genre forgiveness bafsid downloadnotes created moddate pagevsn)

  has_many :author_profiles

  has_one :editor, class_name: 'Member', foreign_key: :editedby

  def custom_links(options = {})
    links = super
    if _model.coverart.present?
      uri = URI(_model.coverart)
      if uri.query
        uri.query += '&'
      else
        uri.query = ''
      end
      links[:coverart] = uri.to_s + 'ldesc'
      links[:thumbnail] = uri.to_s + 'thumbnail=80x80'
      links[:large_thumbnail] = uri.to_s + 'thumbnail=175x175'
    end
    links[:website] = _model.website if _model.website.present?
    links
  end
end
