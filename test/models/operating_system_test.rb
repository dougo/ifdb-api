require 'test_helper'

class OperatingSystemTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should have_many(:versions).class_name('OperatingSystemVersion').with_foreign_key(:osid)
end
