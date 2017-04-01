class GameResource < ApplicationResource
  attributes *%i(title sort_title author sort_author authorExt seriesnumber seriesname genre
                 ratings_average ratings_count tags published version license system language
                 language_names desc forgiveness ifids bafsid downloadnotes created
                 moddate pagevsn players_count wishlists_count)

  has_many :author_profiles, :ratings
  has_one :editor, class_name: 'Member', foreign_key: :editedby
  has_many :players, :wishlists

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

  def ratings_average
    # TODO: this is more efficient but causes N+1 queries.
    # _model.ratings.average(:rating)&.to_f
    ratings = _model.ratings.map(&:rating)
    ratings.sum / ratings.count.to_f if ratings.any?
  end

  def ratings_count
    _model.ratings.size
  end

  def ifids
    _model.ifids.map &:to_s
  end

  def players_count
    _model.players.size
  end

  def wishlists_count
    _model.wishlists.size
  end

  def self.records(options)
    Game.includes *%i(ratings ifids players wishlists)
  end

  private

  def add_param(uri, key, value = nil)
    uri = URI(uri)
    uri.query = Rack::Utils.parse_query(uri.query).merge(key.to_s => value).to_query
    uri.to_s
  end
end
