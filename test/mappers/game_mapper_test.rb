require 'test_helper'

class GameMapperTest < ActiveSupport::TestCase
  test 'is a Mapper' do
    assert_equal Yaks::Mapper, GameMapper.superclass
  end

  test 'attributes' do
    attrs = %i(id title sort_title author sort_author authorExt tags published version license system language desc
               coverart seriesname seriesnumber genre forgiveness)
    assert_equal attrs, GameMapper.config.attributes.map(&:name)
  end

  test 'self link' do
    link = GameMapper.config.links.first
    assert_equal :self, link.rel
    assert_equal '/games/{id}', link.template
  end

  test 'conforms to schema' do
    assert_valid_json GameSchema.new, games(:zork).to_hal
  end
end
