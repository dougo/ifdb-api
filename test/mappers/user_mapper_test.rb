require 'test_helper'

class UserMapperTest < ActiveSupport::TestCase
  test 'is an ApplicationMapper' do
    assert_equal ApplicationMapper, UserMapper.superclass
  end

  test 'attributes' do
    attrs = %i(id name gender publicemail location profile picture created)
    assert_equal attrs, UserMapper.config.attributes.map(&:name)
  end

  test 'self link' do
    link = UserMapper.config.links.first
    assert_equal :self, link.rel
    assert_equal '/users/{id}', link.template
  end

  test 'conforms to schema' do
    schema = HAL::UserSchema.new
    assert_valid_json schema, users(:minimal).to_hal
    assert_valid_json schema, users(:maximal).to_hal
  end
end
