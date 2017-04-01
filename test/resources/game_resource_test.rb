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

  class GameResource::SerializerTest < ActiveSupport::TestCase
    test_extends JSONAPI::ResourceSerializer

    subject { self.class.described_type.new(GameResource) }

    test 'link_builder' do
      assert_kind_of GameResource::LinkBuilder, subject.link_builder
    end
  end

  class GameResource::LinkBuilderTest < ActiveSupport::TestCase
    test_extends JSONAPI::LinkBuilder

    subject do
      self.class.described_type.new(base_url: 'http://www.example.com',
                                    route_formatter: JSONAPI.configuration.route_formatter,
                                    primary_resource_klass: GameResource)
    end

    test 'relationships_related_link includes meta if relationship has meta' do
      resource = GameResource.new(games(:maximal), {})
      relationship = JSONAPI::Relationship::ToMany.new(:ratings, meta: proc { { count: ratings_count } })
      expected = {
        href: "http://www.example.com/games/#{games(:maximal).id}/ratings",
        meta: { count: 3 }
      }
      assert_equal expected, subject.relationships_related_link(resource, relationship)
    end

    test 'relationships_related_link is string if relationship has no meta' do
      resource = GameResource.new(Game.new(id: 'xyzzy'), {})
      relationship = JSONAPI::Relationship::ToMany.new(:ratings)
      expected = 'http://www.example.com/games/xyzzy/ratings'
      assert_equal expected, subject.relationships_related_link(resource, relationship)
    end
  end
end
