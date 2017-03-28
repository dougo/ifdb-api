require 'test_helper'

class GameResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  test_attributes %i(title sort_title author sort_author authorExt tags published version license system language
                     desc seriesname seriesnumber genre forgiveness bafsid downloadnotes created
                     moddate pagevsn players_count wishlists_count)

  test 'author_profiles relationship' do
    assert_kind_of JSONAPI::Relationship::ToMany, GameResource._relationship(:author_profiles)
  end

  test 'editor relationship' do
    rel = GameResource._relationship(:editor)
    assert_kind_of JSONAPI::Relationship::ToOne, rel
    assert_equal 'Member', rel.class_name
    assert_equal :editedby, rel.foreign_key
  end

  test 'players relationship' do
    assert_kind_of JSONAPI::Relationship::ToMany, GameResource._relationship(:players)
  end

  test 'wishlists relationship' do
    assert_kind_of JSONAPI::Relationship::ToMany, GameResource._relationship(:wishlists)
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

  test 'players_count' do
    subject._model.players.build([{}, {}])
    assert_equal 2, subject.players_count
  end

  test 'wishlists_count' do
    subject._model.wishlists.build([{}, {}])
    assert_equal 2, subject.wishlists_count
  end

  test 'records includes players and wishlists to avoid 2N+1 queries' do
    assert_predicate GameResource.records({}).first.players, :loaded?
    assert_predicate GameResource.records({}).first.wishlists, :loaded?
  end

  test 'conforms to schema' do
    schema = GameSchema.new
    assert_valid_json schema, serialize(games(:minimal))
    assert_valid_json schema, serialize(games(:maximal))
  end
end
