require 'test_helper'

class UserMapperTest < ActiveSupport::TestCase
  test 'is a Mapper' do
    assert_equal Yaks::Mapper, UserMapper.superclass
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
    assert_valid_json UserSchema.new, users(:molydeux).to_hal
  end
end
