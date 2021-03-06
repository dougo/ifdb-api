require 'test_helper'

class GameResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  test_attributes %i(title sort_title author sort_author authorExt seriesnumber seriesname genre
                     tags published version license system language language_names desc forgiveness ifids bafsid
                     downloadnotes created moddate pagevsn)

  test_has_many *%i(author_profiles ratings editorial_reviews member_reviews players wishlists download_links)

  test 'editor relationship' do
    rel = GameResource._relationship(:editor)
    assert_kind_of JSONAPI::Relationship::ToOne, rel
    assert_equal 'Member', rel.class_name
    assert_equal :editedby, rel.foreign_key
  end

  test 'custom links' do
    subject._model.coverart = 'http://example.com?coverart'
    subject._model.website = 'http://example.com'
    subject._model.bafsid = 123
    links = subject.custom_links(serializer: JSONAPI::ResourceSerializer.new(GameResource))
    assert_equal 'include=author-profiles%2Ceditorial-reviews.special-reviewer%2C' +
                 'editorial-reviews.offsite-review%2Ceditorial-reviews.reviewer%2C' +
                 'member-reviews.reviewer%2Cdownload-links', URI(links['self']).query
    assert_equal 'http://example.com?coverart&ldesc', links[:coverart]
    assert_equal 'http://example.com?coverart&thumbnail=80x80', links[:thumbnail]
    assert_equal 'http://example.com?coverart&thumbnail=175x175', links[:large_thumbnail]
    assert_equal 'http://example.com', links[:website]
    assert_equal 'http://www.wurb.com/if/game/123', links[:bafs_guide]
  end

  test 'custom links ignore blanks' do
    subject._model.coverart = ''
    subject._model.website = nil
    links = subject.custom_links(serializer: JSONAPI::ResourceSerializer.new(GameResource))
    refute_includes links, :coverart
    refute_includes links, :thumbnail
    refute_includes links, :large_thumbnail
    refute_includes links, :website
    refute_includes links, :bafs_guide
  end

  test 'links when coverart has no query' do
    subject._model.coverart = 'http://example.com'
    links = subject.custom_links(serializer: JSONAPI::ResourceSerializer.new(GameResource))
    assert_equal 'http://example.com?ldesc', links[:coverart]
    assert_equal 'http://example.com?thumbnail=80x80', links[:thumbnail]
    assert_equal 'http://example.com?thumbnail=175x175', links[:large_thumbnail]
  end

  test 'ratings_includes' do
    assert_equal %w(game.author-profiles reviewer), subject.ratings_includes
  end

  test 'ratings_meta' do
    subject = GameResource.new(games(:maximal), {})
    assert_equal({ average: 3.25, count: 4 }, subject.ratings_meta({}))
  end

  test 'ratings average is nil if no ratings' do
    assert_equal({ average: nil, count: 0 }, subject.ratings_meta({}))
  end

  test 'records_for_editorial_reviews' do
    relation = subject.records_for_editorial_reviews
    assert_equal 2, relation.order_values.length

    order_value = relation.order_values.first
    assert_kind_of Arel::Nodes::Ascending, order_value
    assert_equal SpecialReviewer.table_name, order_value.expr.relation.name
    assert_equal :displayrank, order_value.expr.name

    order_value = relation.order_values.last
    assert_kind_of Arel::Nodes::Ascending, order_value
    assert_equal OffsiteReview.table_name, order_value.expr.relation.name
    assert_equal :displayorder, order_value.expr.name
  end

  test 'ifids' do
    subject._model.ifids.build([{ ifid: 'foo' }, { ifid: 'bar' }])
    assert_equal %w(foo bar), subject.ifids
  end

  test 'member_reviews_includes' do
    assert_equal %w(game.author-profiles reviewer), subject.member_reviews_includes
  end

  test 'member_reviews_meta' do
    subject._model.member_reviews.build([{}, {}])
    assert_equal({ count: 2 }, subject.member_reviews_meta({}))
  end

  test 'players_meta' do
    subject._model.players.build([{}, {}])
    assert_equal({ count: 2 }, subject.players_meta({}))
  end

  test 'wishlists_meta' do
    subject._model.wishlists.build([{}, {}])
    assert_equal({ count: 2 }, subject.wishlists_meta({}))
  end

  # TODO: only when relationships are not omitted from sparse fieldset
  # TODO: only include relationships needed for count/average if we're loading multiple records at once?
  test 'records includes relationships to avoid N+1 queries' do
    subject = GameResource.records({}).first
    assert_predicate subject.ratings, :loaded?
    assert_predicate subject.ifids, :loaded?
    assert_predicate subject.member_reviews, :loaded?
    assert_predicate subject.players, :loaded?
    assert_predicate subject.wishlists, :loaded?
  end

  test 'conforms to schema' do
    schema = GameSchema.new
    assert_valid_json schema, serialize(games(:minimal))
    assert_valid_json schema, serialize(games(:maximal))
  end
end
