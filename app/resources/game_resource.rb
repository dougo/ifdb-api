class GameResource < ApplicationResource
  attributes *%i(title sort_title author sort_author authorExt seriesnumber seriesname genre
                 tags published version license system language language_names desc forgiveness ifids bafsid
                 downloadnotes created moddate pagevsn)

  has_many *%i(author_profiles editorial_reviews ratings member_reviews) # TODO: three_most_helpful_member_reviews?
  has_one :editor, class_name: 'Member', foreign_key: :editedby
  has_many *%i(players wishlists download_links)

  def custom_links(options = {})
    links = super
    if _model.coverart.present?
      links[:coverart] = add_param(_model.coverart, :ldesc)
      links[:thumbnail] = add_param(_model.coverart, :thumbnail, '80x80')
      links[:large_thumbnail] = add_param(_model.coverart, :thumbnail, '175x175')
    end
    links[:website] = _model.website if _model.website.present?
    links[:bafs_guide] = "http://www.wurb.com/if/game/#{_model.bafsid}" if _model.bafsid
    links
  end

  def records_for_editorial_reviews
    rel =_model.editorial_reviews.unscope(:order)
    rel = rel.joins(:special_reviewer).merge(SpecialReviewer.order(:displayrank))
    rel = rel.left_outer_joins(:offsite_review).merge(OffsiteReview.order(:displayorder))
    rel
  end

  def ratings_meta(options)
    { average: ratings_average, count: _model.ratings.size }
  end

  def ifids
    _model.ifids.map &:to_s
  end

  def member_reviews_meta(options)
    { count: _model.member_reviews.size }
  end

  def players_meta(options)
    { count: _model.players.size }
  end

  def wishlists_meta(options)
    { count: _model.wishlists.size }
  end

  def self.records(options)
    Game.includes *%i(ratings ifids member_reviews players wishlists)
  end

  private

  def add_param(uri, key, value = nil)
    uri = URI(uri)
    uri.query = Rack::Utils.parse_query(uri.query).merge(key.to_s => value).to_query
    uri.to_s
  end

  def ratings_average
    # TODO: this is more efficient but causes N+1 queries.
    # _model.ratings.average(:rating)&.to_f
    ratings = _model.ratings.map(&:rating)
    ratings.sum / ratings.size.to_f if ratings.any?
  end
end
