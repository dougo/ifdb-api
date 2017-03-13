require 'test_helper'

class OperatingSystemTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should have_many(:versions).class_name('OperatingSystemVersion').with_foreign_key(:osid)
end
