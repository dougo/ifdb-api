require 'test_helper'

class YNBooleanTest < ActiveSupport::TestCase
  test_extends ActiveRecord::Type::Boolean

  test 'serialize true' do
    assert_equal 'Y', subject.serialize(true)
  end

  test 'serialize false' do
    assert_equal 'N', subject.serialize(false)
  end

  test 'deserialize Y' do
    assert_equal true, subject.deserialize('Y')
  end

  test 'deserialize N' do
    assert_equal false, subject.deserialize('N')
  end
end
