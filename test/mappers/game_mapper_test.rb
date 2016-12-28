require 'test_helper'

class GameMapperTest < ActiveSupport::TestCase
  test 'is a Mapper' do
    assert_equal Yaks::Mapper, GameMapper.superclass
  end

  test 'attributes' do
    assert_equal %i(id title sort_title author sort_author authorExt tags), GameMapper.config.attributes.map(&:name)
  end

  test 'self link' do
    link = GameMapper.config.links.first
    assert_equal :self, link.rel
    assert_equal '/games/{id}', link.template
  end

  test 'conforms to schema' do
    json = Yaks.new.call(games(:zork))
    assert_valid_json GameSchema.new, json
  end
end
