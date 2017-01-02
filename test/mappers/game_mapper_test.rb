require 'test_helper'

class GameMapperTest < ActiveSupport::TestCase
  test 'is a Mapper' do
    assert_equal Yaks::Mapper, GameMapper.superclass
  end

  test 'attributes' do
    attrs = %i(id title sort_title author sort_author authorExt tags published version license system language desc
               coverart seriesname seriesnumber genre forgiveness bafsid website downloadnotes created editedby
               moddate pagevsn)
    assert_equal attrs, GameMapper.config.attributes.map(&:name)
  end

  test 'links' do
    links = GameMapper.config.links.group_by &:rel
    # TODO: use URL helpers, e.g. game_path(game) ?
    assert_equal '/games/{id}', links[:self][0].template
    assert_equal '/users/{author_id}',    links[:author][0].template
    assert_kind_of Proc, links[:author][0].options[:if]
    assert_equal '/users?id={author_id}', links[:author][1].template
    assert_kind_of Proc, links[:author][1].options[:if]
  end

  test 'conforms to schema' do
    assert_valid_json GameSchema.new, games(:zork).to_hal
  end

  test 'author link only if author ID exists' do
    adv = JSON.parse(games(:adventure).to_hal).deep_symbolize_keys
    assert_equal '/users/willc', adv[:_links][:author][:href]

    zork = JSON.parse(games(:zork).to_hal).deep_symbolize_keys
    refute_includes zork[:_links], :author
  end

  test 'author link is a collection if multiple author IDs' do
    game = Game.new(authorExt: 'Xavier Yzzy {xyzzy} and Phineas Lugh {plugh}')
    hal = JSON.parse(game.to_hal).deep_symbolize_keys
    assert_equal '/users?id=xyzzy,plugh', hal[:_links][:author][:href]
  end
end
