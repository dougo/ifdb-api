require 'test_helper'

class OperatingSystemVersionTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should belong_to(:operating_system).with_foreign_key(:osid)
end
