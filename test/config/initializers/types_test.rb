require 'test_helper'

class TypesTest < ActiveSupport::TestCase
  test 'yn_boolean type' do
    assert_kind_of YNBoolean, ActiveRecord::Type.lookup(:yn_boolean)
  end

  test 'source_type_name type' do
    subject = ActiveRecord::Type.lookup(:source_type_name, name_map: { 'Q' => 'Qanat' })
    assert_kind_of SourceTypeName, subject
    assert_equal({ 'Q' => 'Qanat' }, subject.name_map)
  end
end
