require 'test_helper'

class SourceTypeNameTest < ActiveSupport::TestCase
  test_extends ActiveRecord::Type::String

  subject { self.class.described_type.new(name_map: { 'Q' => 'Qanat' } ) }

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
