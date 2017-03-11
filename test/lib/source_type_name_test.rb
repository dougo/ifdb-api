require 'test_helper'

class SourceTypeNameTest < ActiveSupport::TestCase
  test 'is a String' do
    assert_operator self.class.described_type, :<, ActiveRecord::Type::String
  end

  subject { self.class.described_type.new('Q' => 'Qanat') }

  test 'name_map' do
    assert_equal({ 'Q' => 'Qanat' }, subject.name_map)
  end

  test 'serialize' do
    assert_equal 'Q', subject.serialize('Qanat')
  end

  test 'deserialize' do
    assert_equal 'Qanat', subject.deserialize('Q')
  end

  test 'serialize unknown type' do
    assert_nil subject.serialize('Xebec')
  end

  test 'deserialize unknown type' do
    assert_nil subject.deserialize('X')
  end
end
