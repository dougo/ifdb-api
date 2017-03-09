require 'test_helper'

class MemberMapperTest < ActiveSupport::TestCase
  test 'is an ApplicationMapper' do
    assert_equal ApplicationMapper, MemberMapper.superclass
  end

  test 'attributes' do
    attrs = %i(id name gender publicemail location profile picture created)
    assert_equal attrs, MemberMapper.config.attributes.map(&:name)
  end

  test 'self link' do
    link = MemberMapper.config.links.first
    assert_equal :self, link.rel
    assert_equal '/members/{id}', link.template
  end

  test 'conforms to schema' do
    schema = HAL::MemberSchema.new
    assert_valid_json schema, members(:minimal).to_hal
    assert_valid_json schema, members(:maximal).to_hal
  end
end
