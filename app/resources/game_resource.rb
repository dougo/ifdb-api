class GameResource < ApplicationResource
  attributes *%i(title sort_title author sort_author authorExt tags published version license system language desc
                 seriesname seriesnumber genre forgiveness bafsid downloadnotes created moddate pagevsn)

  has_many :author_profiles

  has_one :editor, class_name: 'Member', foreign_key: :editedby

  def custom_links(options = {})
    links = super
    if _model.coverart.present?
      links[:coverart] = _model.coverart
      thumbnail = URI(_model.coverart)
      if thumbnail.query
        thumbnail.query += '&thumbnail=80x80'
      else
        thumbnail.query = 'thumbnail=80x80'
      end
      links[:thumbnail] = thumbnail.to_s
    end
    links[:website] = _model.website if _model.website.present?
    links
  end
end
