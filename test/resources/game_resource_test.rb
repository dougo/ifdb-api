require 'test_helper'

class GameResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  test_attributes %i(title sort_title author sort_author authorExt seriesnumber seriesname genre
                     ratings_average ratings_count tags published version license system language
                     language_names desc forgiveness ifids bafsid downloadnotes created
                     moddate pagevsn players_count wishlists_count)

  test_has_many *%i(author_profiles ratings players wishlists)

  test 'editor relationship' do
    rel = GameResource._relationship(:editor)
    assert_kind_of JSONAPI::Relationship::ToOne, rel
    assert_equal 'Member', rel.class_name
    assert_equal :editedby, rel.foreign_key
  end

  test 'ratings relationship includes count' do
    subject = GameResource.new(games(:maximal), {})
    meta = GameResource._relationship(:ratings).options[:meta]
    assert_equal({ count: 3 }, subject.instance_eval(&meta))
  end

  test 'custom links' do
    subject._model.coverart = 'http://example.com?coverart'
    subject._model.website = 'http://example.com'
    assert_equal 'http://example.com?coverart&ldesc', subject.custom_links[:coverart]
    assert_equal 'http://example.com?coverart&thumbnail=80x80', subject.custom_links[:thumbnail]
    assert_equal 'http://example.com?coverart&thumbnail=175x175', subject.custom_links[:large_thumbnail]
    assert_equal 'http://example.com', subject.custom_links[:website]
  end

  test 'custom links ignore blanks' do
    subject._model.coverart = ''
    subject._model.website = nil
    refute_includes subject.custom_links, :coverart
    refute_includes subject.custom_links, :thumbnail
    refute_includes subject.custom_links, :large_thumbnail
    refute_includes subject.custom_links, :website
  end

  test 'links when coverart has no query' do
    subject._model.coverart = 'http://example.com'
    assert_equal 'http://example.com?ldesc', subject.custom_links[:coverart]
    assert_equal 'http://example.com?thumbnail=80x80', subject.custom_links[:thumbnail]
    assert_equal 'http://example.com?thumbnail=175x175', subject.custom_links[:large_thumbnail]
  end

  test 'ratings_average and ratings_count' do
    subject = GameResource.new(games(:maximal), {})
    assert_equal 3.3333333333333333, subject.ratings_average.as_json
    assert_equal 3, subject.ratings_count
  end

  test 'ratings_average is nil if no ratings' do
    assert_nil subject.ratings_average
  end

  test 'ifids' do
    subject._model.ifids.build([{ ifid: 'foo' }, { ifid: 'bar' }])
    assert_equal %w(foo bar), subject.ifids
  end

  test 'players_count' do
    subject._model.players.build([{}, {}])
    assert_equal 2, subject.players_count
  end

  test 'wishlists_count' do
    subject._model.wishlists.build([{}, {}])
    assert_equal 2, subject.wishlists_count
  end

  test 'records includes relationships to avoid N+1 queries' do
    subject = GameResource.records({}).first
    assert_predicate subject.ratings, :loaded?
    assert_predicate subject.ifids, :loaded?
    assert_predicate subject.players, :loaded?
    assert_predicate subject.wishlists, :loaded?
  end

  test 'conforms to schema' do
    schema = GameSchema.new
    assert_valid_json schema, serialize(games(:minimal))
    assert_valid_json schema, serialize(games(:maximal))
  end
end
