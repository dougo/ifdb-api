require 'test_helper'

class TypesTest < ActiveSupport::TestCase
  test 'yn_boolean type' do
    assert_kind_of YNBoolean, ActiveRecord::Type.lookup(:yn_boolean)
  end
end
