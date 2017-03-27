class GameResource < ApplicationResource
  attributes *%i(title sort_title author sort_author authorExt tags published version license system language desc
                 seriesname seriesnumber genre forgiveness bafsid downloadnotes created moddate pagevsn)

  has_many :author_profiles

  has_one :editor, class_name: 'Member', foreign_key: :editedby

  def custom_links(options = {})
    links = super
    if _model.coverart.present?
      links[:coverart] = add_param(_model.coverart, :ldesc)
      links[:thumbnail] = add_param(_model.coverart, :thumbnail, '80x80')
      links[:large_thumbnail] = add_param(_model.coverart, :thumbnail, '175x175')
    end
    links[:website] = _model.website if _model.website.present?
    links
  end

  private

  def add_param(uri, key, value = nil)
    uri = URI(uri)
    uri.query = Rack::Utils.parse_query(uri.query).merge(key.to_s => value).to_query
    uri.to_s
  end
end
