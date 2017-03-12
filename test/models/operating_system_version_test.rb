require 'test_helper'

class OperatingSystemVersionTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should belong_to(:operating_system).with_foreign_key(:osid)
end
