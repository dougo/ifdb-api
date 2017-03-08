require 'test_helper'

class GameMapperTest < ActiveSupport::TestCase
  test 'is an ApplicationMapper' do
    assert_equal ApplicationMapper, GameMapper.superclass
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
  end

  test 'conforms to schema' do
    assert_valid_json HAL::GameSchema.new, games(:zork).to_hal
  end
end
