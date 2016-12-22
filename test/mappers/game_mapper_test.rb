require 'test_helper'

class GameMapperTest < ActiveSupport::TestCase
  test 'attributes' do
    assert_equal %i(id title sort_title author sort_author), GameMapper.config.attributes.map(&:name)
  end
end
